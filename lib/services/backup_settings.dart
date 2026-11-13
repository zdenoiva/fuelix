import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupTarget {
  const BackupTarget({required this.uri, required this.name});

  final String uri;
  final String name;
}

/// Stores the reusable backup password (Android Keystore backed) and the
/// remembered backup destination.
class BackupSettings {
  BackupSettings._();

  static const _secure = FlutterSecureStorage();
  static const _passwordKey = 'backup_password';
  static const _targetUriKey = 'backup_target_uri';
  static const _targetNameKey = 'backup_target_name';

  static Future<String?> password() => _secure.read(key: _passwordKey);

  static Future<bool> hasPassword() async =>
      (await _secure.read(key: _passwordKey))?.isNotEmpty ?? false;

  static Future<void> setPassword(String value) =>
      _secure.write(key: _passwordKey, value: value);

  static Future<void> clearPassword() => _secure.delete(key: _passwordKey);

  static Future<BackupTarget?> target() async {
    final prefs = await SharedPreferences.getInstance();
    final uri = prefs.getString(_targetUriKey);
    final name = prefs.getString(_targetNameKey);
    if (uri == null || name == null) return null;
    return BackupTarget(uri: uri, name: name);
  }

  static Future<void> setTarget(BackupTarget target) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_targetUriKey, target.uri);
    await prefs.setString(_targetNameKey, target.name);
  }

  static Future<void> clearTarget() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_targetUriKey);
    await prefs.remove(_targetNameKey);
  }
}

/// Native bridge for a persisted Android document URI, so the second and every
/// later backup can be written to the same file without a picker.
class BackupTargetService {
  BackupTargetService._();

  static const MethodChannel _channel = MethodChannel(
    'sk.zdenoiva.fuelix/backup',
  );

  static Future<BackupTarget?> pick() async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'pickTarget',
    );
    if (result == null) return null;
    final uri = result['uri'] as String?;
    final name = result['name'] as String?;
    if (uri == null || name == null) return null;
    return BackupTarget(uri: uri, name: name);
  }

  static Future<bool> write(String uri, Uint8List bytes) async {
    try {
      return await _channel.invokeMethod<bool>('writeTarget', {
            'uri': uri,
            'bytes': bytes,
          }) ??
          false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> release(String uri) async {
    try {
      await _channel.invokeMethod<bool>('releaseTarget', {'uri': uri});
    } catch (_) {
      // Nothing to do – the permission simply stops being used.
    }
  }
}
