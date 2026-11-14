import 'package:flutter_test/flutter_test.dart';
import 'package:fuelix/services/ekasa_service.dart';
import 'package:fuelix/services/receipt_scanner.dart';

Map<String, dynamic> fuelReceipt({String itemName = 'Natural FuelSave'}) => {
  'receiptId': 'O-AC6D5656CDC64336AD5656CDC60336E0',
  'issueDate': '14.11.2026 09:09:44',
  'totalPrice': 75.01,
  'items': [
    {
      'name': itemName,
      'quantity': 46.190,
      'price': 1.624,
      'vatRate': 23,
    },
  ],
  'organization': {'name': 'HAPPE s.r.o.'},
  'unit': {'name': '8201 - ČS Shell Prievidza'},
};

void main() {
  group('UID detection', () {
    test('reads a plain eKasa UID', () {
      expect(
        ReceiptParser.extractUid('O-AC6D5656CDC64336AD5656CDC60336E0'),
        'O-AC6D5656CDC64336AD5656CDC60336E0',
      );
    });

    test('reads a UID from a URL or text', () {
      expect(
        ReceiptParser.extractUid(
          'https://opd.financnasprava.sk/check?id=O-AC6D5656CDC64336AD5656CDC60336E0',
        ),
        'O-AC6D5656CDC64336AD5656CDC60336E0',
      );
    });

    test('accepts lower case and the 0/O mix-up', () {
      expect(
        ReceiptParser.extractUid('o-AC6D5656CDC64336AD5656CDC60336E0'),
        'O-AC6D5656CDC64336AD5656CDC60336E0',
      );
      expect(
        ReceiptParser.extractUid('0-AC6D5656CDC64336AD5656CDC60336E0'),
        '0-AC6D5656CDC64336AD5656CDC60336E0',
      );
    });

    test('ignores random text', () {
      expect(ReceiptParser.extractUid('dakujeme za nakup'), isNull);
    });

    test('parse returns the UID for an online lookup', () {
      final data = ReceiptParser.parse('O-AC6D5656CDC64336AD5656CDC60336E0');
      expect(data, isNotNull);
      expect(data!.receiptId, 'O-AC6D5656CDC64336AD5656CDC60336E0');
      expect(data.hasValues, isFalse);
      expect(data.requiresOnline, isTrue);
    });
  });

  group('eKasa receipt', () {
    test('turns the fuel line into a fill-up draft', () {
      final receipt = EkasaReceipt.fromJson(fuelReceipt());
      final data = receipt.toReceiptData();

      expect(data, isNotNull);
      expect(data!.liters, closeTo(46.190, 0.001));
      expect(data.pricePerLiter, closeTo(1.624, 0.0001));
      expect(data.total, closeTo(75.01, 0.001));
      expect(data.stationName, '8201 - ČS Shell Prievidza');
      expect(data.date, DateTime(2026, 11, 14, 9, 9, 44));
    });

    test('detects the fuel line from its name among other items', () {
      final json = fuelReceipt();
      json['items'] = [
        {'name': 'Bageta', 'quantity': 1, 'price': 2.5},
        {'name': 'Diesel', 'quantity': 30.0, 'price': 1.55},
        {'name': 'Káva', 'quantity': 1, 'price': 1.2},
      ];
      final data = EkasaReceipt.fromJson(json).toReceiptData();
      expect(data!.liters, 30);
      expect(data.pricePerLiter, closeTo(1.55, 0.001));
    });

    test('returns null for a grocery-only receipt', () {
      final json = fuelReceipt();
      json['items'] = [
        {'name': 'Rožok', 'quantity': 3, 'price': 0.2},
        {'name': 'Mlieko', 'quantity': 1, 'price': 1.1},
      ];
      expect(EkasaReceipt.fromJson(json).toReceiptData(), isNull);
    });

    test('builds an expense draft with item lines', () {
      final json = fuelReceipt();
      json['items'] = [
        {'name': 'Bageta', 'quantity': 2, 'price': 2.5},
        {'name': 'Káva', 'quantity': 1, 'price': 1.2},
      ];
      final data = EkasaReceipt.fromJson(json).toExpenseData();
      expect(data.total, closeTo(75.01, 0.001));
      expect(data.items, hasLength(2));
      expect(data.items.first.name, 'Bageta');
      expect(data.items.first.total, closeTo(5.0, 0.001));
      expect(data.merchant, '8201 - ČS Shell Prievidza');
      expect(data.date, DateTime(2026, 11, 14, 9, 9, 44));
    });

    test('falls back to the brand when the unit has no name', () {
      final json = fuelReceipt();
      json['unit'] = {'name': null};
      final data = EkasaReceipt.fromJson(json).toReceiptData();
      expect(data!.stationName, 'Shell');
    });
  });
}
