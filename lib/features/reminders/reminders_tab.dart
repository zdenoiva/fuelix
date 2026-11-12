import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../data/database.dart';
import '../../domain/presets.dart';
import '../../l10n/strings.dart';
import '../../util/context_format.dart';
import '../../widgets/common.dart';
import 'reminder_form_screen.dart';

class RemindersTab extends StatefulWidget {
  const RemindersTab({super.key, required this.vehicleId, required this.onAdd});

  final int vehicleId;
  final VoidCallback onAdd;

  @override
  State<RemindersTab> createState() => _RemindersTabState();
}

class _RemindersTabState extends State<RemindersTab> {
  final _repo = AppState.instance.repo;
  double _currentOdometer = 0;

  @override
  void initState() {
    super.initState();
    _loadOdometer();
  }

  Future<void> _loadOdometer() async {
    final last = await _repo.lastFillUp(widget.vehicleId);
    if (!mounted) return;
    setState(() => _currentOdometer = last?.odometer ?? 0);
  }

  Future<void> _openForm({Reminder? reminder, ServicePreset? preset}) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ReminderFormScreen(
          vehicleId: widget.vehicleId,
          reminder: reminder,
          preset: preset,
        ),
      ),
    );
    await _loadOdometer();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return StreamBuilder<List<Reminder>>(
      stream: _repo.watchReminders(widget.vehicleId),
      builder: (context, snapshot) {
        final reminders = snapshot.data;
        if (reminders == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          children: [
            Text(
              context.t('reminder.add'),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final preset in servicePresets)
                  ActionChip(
                    avatar: Icon(_presetIcon(preset.category), size: 16),
                    label: Text(context.t(preset.labelKey)),
                    onPressed: () => _openForm(preset: preset),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.t('reminder.title'),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${context.num1(_currentOdometer)} km',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (reminders.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Text(
                  context.t('reminder.empty'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            for (final reminder in reminders)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ReminderTile(
                  reminder: reminder,
                  currentOdometer: _currentOdometer,
                  onTap: () => _openForm(reminder: reminder),
                ),
              ),
          ],
        );
      },
    );
  }

  IconData _presetIcon(String category) => switch (category) {
    'inspection' => Icons.verified_outlined,
    'insurance' => Icons.shield_outlined,
    'tires' => Icons.tire_repair_outlined,
    _ => Icons.build_outlined,
  };
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.reminder,
    required this.currentOdometer,
    required this.onTap,
  });

  final Reminder reminder;
  final double currentOdometer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final daysLeft = reminder.dueDate
        ?.difference(DateTime.now())
        .inDays;
    final kmLeft = reminder.dueOdometer == null
        ? null
        : reminder.dueOdometer! - currentOdometer;

    final overdue =
        (daysLeft != null && daysLeft < 0) || (kmLeft != null && kmLeft < 0);
    final soon =
        (daysLeft != null && daysLeft <= reminder.advanceDays) ||
        (kmLeft != null && kmLeft <= reminder.advanceKm);

    String status;
    if (overdue) {
      status = context.t('reminder.overdue');
    } else if (daysLeft != null && daysLeft == 0) {
      status = context.t('reminder.dueToday');
    } else if (daysLeft != null) {
      status = context.t('reminder.inDays', {'n': daysLeft});
    } else if (kmLeft != null) {
      status = context.t('reminder.inKm', {'n': context.num1(kmLeft)});
    } else {
      status = context.t('reminder.noDue');
    }

    final color = overdue
        ? scheme.error
        : soon
        ? const Color(0xFFF59E0B)
        : scheme.onSurfaceVariant;

    return SectionCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.notifications_active_outlined, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    if (reminder.dueDate != null)
                      context.date(reminder.dueDate!),
                    if (reminder.dueOdometer != null)
                      '${context.num1(reminder.dueOdometer!)} km',
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            status,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
