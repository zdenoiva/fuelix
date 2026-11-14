import 'package:flutter/widgets.dart';

/// Resets the app to its home screen after a long time in the background.
class LifecycleService with WidgetsBindingObserver {
  LifecycleService._();

  static final LifecycleService instance = LifecycleService._();

  static const Duration absenceTimeout = Duration(minutes: 15);

  DateTime? _pausedAt;
  VoidCallback? _onLongAbsence;
  bool _registered = false;

  void init(VoidCallback onLongAbsence) {
    _onLongAbsence = onLongAbsence;
    if (_registered) return;
    WidgetsBinding.instance.addObserver(this);
    _registered = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _pausedAt ??= DateTime.now();
      case AppLifecycleState.resumed:
        final pausedAt = _pausedAt;
        _pausedAt = null;
        if (pausedAt != null &&
            DateTime.now().difference(pausedAt) > absenceTimeout) {
          _onLongAbsence?.call();
        }
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }
}
