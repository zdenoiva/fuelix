import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

/// Password based encryption for backup files.
///
/// The file is a small JSON envelope so it stays readable in a text editor
/// while the payload itself is AES-GCM encrypted with a PBKDF2 derived key.
class BackupCrypto {
  const BackupCrypto._();

  static const int iterations = 120000;
  static final Random _random = Random.secure();

  static bool isEncrypted(String text) {
    try {
      final decoded = jsonDecode(text);
      return decoded is Map && decoded['format'] == 'encrypted';
    } catch (_) {
      return false;
    }
  }

  static Future<String> encrypt(
    Map<String, Object?> data,
    String password,
  ) async {
    final algorithm = AesGcm.with256bits();
    final salt = List<int>.generate(16, (_) => _random.nextInt(256));
    final key = await _deriveKey(password, salt, iterations);
    final secretBox = await algorithm.encrypt(
      utf8.encode(jsonEncode(data)),
      secretKey: key,
    );

    return jsonEncode({
      'app': 'fuelix',
      'format': 'encrypted',
      'version': 1,
      'kdf': 'pbkdf2-hmac-sha256',
      'iterations': iterations,
      'salt': base64Encode(salt),
      'nonce': base64Encode(secretBox.nonce),
      'mac': base64Encode(secretBox.mac.bytes),
      'cipherText': base64Encode(secretBox.cipherText),
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    });
  }

  /// Throws [SecretBoxAuthenticationError] for a wrong password or a tampered
  /// file, and [FormatException] for anything that is not a backup envelope.
  static Future<Map<String, Object?>> decrypt(
    String text,
    String password,
  ) async {
    final decoded = jsonDecode(text);
    if (decoded is! Map) throw const FormatException('Invalid backup');
    final envelope = Map<String, dynamic>.from(decoded);
    if (envelope['format'] != 'encrypted') {
      throw const FormatException('Backup is not encrypted');
    }

    final rounds =
        int.tryParse('${envelope['iterations'] ?? iterations}') ?? iterations;
    final salt = base64Decode(envelope['salt'] as String);
    final key = await _deriveKey(password, salt, rounds);

    final algorithm = AesGcm.with256bits();
    final secretBox = SecretBox(
      base64Decode(envelope['cipherText'] as String),
      nonce: base64Decode(envelope['nonce'] as String),
      mac: Mac(base64Decode(envelope['mac'] as String)),
    );
    final clear = await algorithm.decrypt(secretBox, secretKey: key);
    final inner = jsonDecode(utf8.decode(clear));
    if (inner is! Map) throw const FormatException('Invalid backup');
    return Map<String, Object?>.from(inner);
  }

  static Future<SecretKey> _deriveKey(
    String password,
    List<int> salt,
    int rounds,
  ) {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: rounds,
      bits: 256,
    );
    return pbkdf2.deriveKeyFromPassword(password: password, nonce: salt);
  }
}
