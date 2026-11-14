import 'package:flutter_test/flutter_test.dart';
import 'package:fuelix/services/receipt_scanner.dart';

void main() {
  // Text as Google ML Kit usually returns it for a Shell receipt.
  const shellText = '''
HAPPE s.r.o.
Budovatelska 262/36, 97212
Nedozery-Brezany

SHELL Prevadzka:
8201 - CS Shell Prievidza
Bojnicka cesta 36, 97101 Prievidza

Datum: 14.11.2026 09:09:44
Pokladna: 2    Transakcia: 4847977

Natural FuelSave           c. stojanu: 3
46.190 L   1.624 Eur/L   23%   75.01 EUR

Cena celkom:                              75.01 EUR

[DPH] [Zaklad]   [Dan]   [Obrat]
23%   60.98   14.03 EUR   75.01 EUR
Spolu: 60.98   14.03 EUR   75.01 EUR

MasterCard:                              75.01 EUR
''';

  test('reads a Shell receipt', () {
    final data = ReceiptParser.parseText(shellText);
    expect(data, isNotNull);
    expect(data!.liters, closeTo(46.190, 0.001));
    expect(data.pricePerLiter, closeTo(1.624, 0.0001));
    expect(data.total, closeTo(75.01, 0.001));
    expect(data.stationName, 'Shell');
  });

  // ML Kit reorders receipt columns: "Cena celkom:" ends up above a totally
  // different line, while "Spolu" is the tax base. The real total (75.01)
  // matches litres × unit price and must win.
  const columnOcrText = '''
HAPPE S.r.o.
SHELL Prevadzka:
Datum: 14.11.2026 09:09:44
Pokladna: 2
Natural FuelSave
Cena celkom:
Transakcia: 4847977
46.190 L 1.624 Eur/L 23% 75.01 EUR
[DPH] [Zaklad]
23% 60.98 14.03 EUR
Spolu: 60.98
MasterCard:
C. stojanu: 3
[Dan]
[Obrat]
75.01 EUR
14.03 EUR 75.01 EUR
75.01 EUR
''';

  test('picks the real total when OCR reorders columns', () {
    final data = ReceiptParser.parseText(columnOcrText);
    expect(data, isNotNull);
    expect(data!.liters, closeTo(46.19, 0.001));
    expect(data.pricePerLiter, closeTo(1.624, 0.0001));
    expect(data.total, closeTo(75.01, 0.001));
  });

  test('handles values split across lines', () {
    const text = '''
SHELL
Natural 95
46,190
L
1,624
Eur/L
Cena celkom:
75,01
EUR
''';
    final data = ReceiptParser.parseText(text);
    expect(data, isNotNull);
    expect(data!.liters, closeTo(46.19, 0.001));
    expect(data.pricePerLiter, closeTo(1.624, 0.0001));
    expect(data.total, closeTo(75.01, 0.001));
  });

  test('computes the missing total from litres and unit price', () {
    const text = 'OMV\n40.000 L\n1.500 Eur/L\n';
    final data = ReceiptParser.parseText(text);
    expect(data, isNotNull);
    expect(data!.total, closeTo(60, 0.001));
    expect(data.stationName, 'OMV');
  });

  test('returns null for a QR payload without prices', () {
    final data = ReceiptParser.parse('0-007EE139E9C45A1BFEE139E9C05A110');
    expect(data, isNull);
  });
}
