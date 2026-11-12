import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../data/database.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Europe/Bratislava'));
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings: settings);

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission();
    _ready = true;
  }

  Future<void> schedule(Reminder reminder) async {
    if (!_ready || reminder.dueDate == null || !reminder.isActive) return;
    final when = reminder.dueDate!.subtract(
      Duration(days: reminder.advanceDays),
    );
    if (when.isBefore(DateTime.now())) return;

    await _plugin.cancel(id: reminder.id);
    await _plugin.zonedSchedule(
      id: reminder.id,
      title: 'Fuelix',
      body: reminder.title,
      scheduledDate: tz.TZDateTime.from(when, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'fuelix_reminders',
          'Servisné pripomienky',
          channelDescription: 'STK, olej, poistenie a ďalšie termíny',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancel(int reminderId) async {
    if (!_ready) return;
    await _plugin.cancel(id: reminderId);
  }

  Future<void> rescheduleAll(List<Reminder> reminders) async {
    if (!_ready) return;
    for (final reminder in reminders) {
      await schedule(reminder);
    }
  }
}
