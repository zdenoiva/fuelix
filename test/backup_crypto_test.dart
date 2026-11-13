import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fuelix/services/backup_crypto.dart';

void main() {
  const payload = <String, Object?>{
    'app': 'fuelix',
    'vehicles': [
      {'id': 1, 'name': 'Test Car'},
    ],
    'fillUps': [
      {'odometer': 1000, 'liters': 40},
    ],
  };

  test('encrypts and decrypts a backup', () async {
    final text = await BackupCrypto.encrypt(payload, 'fuelix123');
    expect(BackupCrypto.isEncrypted(text), isTrue);
    expect(text.contains('Test Car'), isFalse);

    final restored = await BackupCrypto.decrypt(text, 'fuelix123');
    expect(restored['app'], 'fuelix');
    expect((restored['vehicles'] as List).first, containsPair('name', 'Test Car'));
  });

  test('rejects a wrong password', () async {
    final text = await BackupCrypto.encrypt(payload, 'fuelix123');
    await expectLater(
      BackupCrypto.decrypt(text, 'wrong-password'),
      throwsA(isA<SecretBoxAuthenticationError>()),
    );
  });

  test('rejects a tampered file', () async {
    final text = await BackupCrypto.encrypt(payload, 'fuelix123');
    final envelope = text.replaceFirst('"format":"encrypted"', '"format":"encrypted"');
    final tampered = envelope.replaceAllMapped(
      RegExp(r'"cipherText":"(.{10})'),
      (match) => '"cipherText":"${match.group(1)!.split('').reversed.join()}',
    );
    await expectLater(
      BackupCrypto.decrypt(tampered, 'fuelix123'),
      throwsA(isA<SecretBoxAuthenticationError>()),
    );
  });

  test('keeps two encryptions of the same data different', () async {
    final first = await BackupCrypto.encrypt(payload, 'fuelix123');
    final second = await BackupCrypto.encrypt(payload, 'fuelix123');
    expect(first, isNot(equals(second)));
  });
}
