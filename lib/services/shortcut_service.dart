import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Entry point for the home screen widget. The native side either delivers the
/// scan action at cold start or through a method call when the app is alive.
class ShortcutService {
  ShortcutService._();

  static const MethodChannel _channel = MethodChannel(
    'sk.zdenoiva.fuelix/shortcut',
  );

  static Future<void> init(Future<void> Function() onScan) async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'openScanner') await onScan();
    });
    try {
      final initial = await _channel.invokeMethod<bool>('consumeInitialScan');
      if (initial == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) => onScan());
      }
    } catch (_) {
      // The widget is Android only.
    }
  }
}
