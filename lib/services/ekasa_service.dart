import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/station_brand.dart';
import 'receipt_scanner.dart';

/// Looks up a Slovak eKasa receipt by the UID printed on it (and encoded in the
/// QR code). The Financial Administration exposes a public endpoint that the
/// official "Over doklad" app uses as well.
class EkasaService {
  EkasaService._();

  static final EkasaService instance = EkasaService._();

  static const String endpoint =
      'https://ekasa.financnasprava.sk/mdu/api/v1/opd/receipt/find';

  final Map<String, EkasaReceipt?> _cache = {};

  /// Extracts an eKasa UID from arbitrary QR text.
  static String? extractUid(String raw) => ReceiptParser.extractUid(raw);

  /// Tries the UID as printed and the common 0/O mix-up. Returns the raw
  /// receipt so the caller can build a fill-up or an expense draft.
  Future<EkasaReceipt?> lookup(String uid) async {
    final normalized = uid.toUpperCase();
    if (_cache.containsKey(normalized)) return _cache[normalized];

    final candidates = <String>{
      normalized,
      if (normalized.startsWith('0')) 'O${normalized.substring(1)}',
      if (normalized.startsWith('O')) '0${normalized.substring(1)}',
    };

    for (final candidate in candidates) {
      final receipt = await _find(candidate);
      if (receipt != null) {
        _cache[normalized] = receipt;
        return receipt;
      }
    }

    _cache[normalized] = null;
    return null;
  }

  Future<EkasaReceipt?> _find(String receiptId) async {
    try {
      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'receiptId': receiptId}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map) return null;
      final receipt = decoded['receipt'];
      if (receipt is! Map) return null;
      return EkasaReceipt.fromJson(Map<String, dynamic>.from(receipt));
    } catch (_) {
      return null;
    }
  }
}

class EkasaItem {
  const EkasaItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  final String name;
  final double quantity;
  final double unitPrice;

  double get total => quantity * unitPrice;
}

/// Receipt data as returned by the eKasa API.
class EkasaReceipt {
  const EkasaReceipt({
    required this.receiptId,
    required this.items,
    this.totalPrice,
    this.issueDate,
    this.unitName,
    this.organizationName,
  });

  final String receiptId;
  final List<EkasaItem> items;
  final double? totalPrice;
  final DateTime? issueDate;
  final String? unitName;
  final String? organizationName;

  static const _fuelKeywords = [
    'natural',
    'diesel',
    'nafta',
    'benzin',
    'benzín',
    'fuelsave',
    'fuel save',
    'v-power',
    'vpower',
    'lpg',
    'cng',
    'e85',
    'adblue',
    'nafta',
    '95',
    '98',
  ];

  static EkasaReceipt fromJson(Map<String, dynamic> json) {
    final items = <EkasaItem>[];
    for (final raw in (json['items'] as List? ?? const [])) {
      if (raw is! Map) continue;
      final name = (raw['name'] ?? '').toString().trim();
      final quantity = _double(raw['quantity']);
      final price = _double(raw['price']);
      if (name.isEmpty || quantity == null || price == null) continue;
      items.add(
        EkasaItem(name: name, quantity: quantity, unitPrice: price),
      );
    }

    final unit = json['unit'];
    final organization = json['organization'];

    return EkasaReceipt(
      receiptId: (json['receiptId'] ?? '').toString(),
      items: items,
      totalPrice: _double(json['totalPrice']),
      issueDate: _parseDate((json['issueDate'] ?? '').toString()),
      unitName: unit is Map ? _text(unit['name']) : null,
      organizationName:
          organization is Map ? _text(organization['name']) : null,
    );
  }

  /// Picks the fuel line and converts the receipt into the form draft.
  ReceiptData? toReceiptData() {
    if (items.isEmpty) return null;

    EkasaItem? fuel;
    for (final item in items) {
      final name = item.name.toLowerCase();
      if (_fuelKeywords.any(name.contains)) {
        fuel = item;
        break;
      }
    }

    // Fallback: a fuel line is a large volume sold per litre. Ordinary grocery
    // receipts must not be mistaken for fuel.
    if (fuel == null) {
      final candidates = items
          .where(
            (item) =>
                item.quantity >= 5 &&
                item.quantity <= 150 &&
                item.unitPrice >= 0.5 &&
                item.unitPrice <= 4,
          )
          .toList();
      if (candidates.isEmpty) return null;
      fuel = candidates.reduce(
        (a, b) => a.quantity >= b.quantity ? a : b,
      );
    }
    if (fuel.quantity <= 0) return null;

    final station = _stationName();
    final total = totalPrice ?? fuel.total;

    return ReceiptData(
      liters: fuel.quantity,
      pricePerLiter: fuel.unitPrice,
      total: total,
      stationName: station,
      merchant: _merchantName(),
      date: issueDate,
      items: _lines(),
      raw: 'ekasa:$receiptId',
    );
  }

  /// Expense draft: no fuel needed, but every item ends up in the note.
  ReceiptData toExpenseData() {
    return ReceiptData(
      total: totalPrice,
      stationName: _stationName(),
      merchant: _merchantName(),
      date: issueDate,
      items: _lines(),
      raw: 'ekasa:$receiptId',
    );
  }

  List<ReceiptLine> _lines() => [
    for (final item in items)
      ReceiptLine(
        name: item.name,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        total: item.total,
      ),
  ];

  String? _merchantName() {
    final unit = unitName?.trim();
    if (unit != null && unit.isNotEmpty) return unit;
    final organization = organizationName?.trim();
    if (organization != null && organization.isNotEmpty) return organization;
    return null;
  }

  /// Only the operating unit is a station. The organisation is the company
  /// behind the pump (e.g. "HAPPE s.r.o."), so it must never replace the real
  /// name – better to leave it empty and let GPS or recent stations fill it.
  String? _stationName() {
    final unit = unitName?.trim();
    if (unit != null && unit.isNotEmpty) return unit;

    // The receipt often has no unit name; the operator company still tells us
    // the brand (for example HAPPE → Shell in Slovakia).
    final brand = StationBrand.detect(
      [unitName, organizationName].whereType<String>().join(' '),
    );
    return brand?.name;
  }

  static String? _text(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  static double? _double(Object? value) {
    if (value is num) return value.toDouble();
    final text = value?.toString().replaceAll(',', '.') ?? '';
    return double.tryParse(text);
  }

  static DateTime? _parseDate(String raw) {
    final match = RegExp(
      r'^(\d{2})\.(\d{2})\.(\d{4})(?:\s+(\d{2}):(\d{2})(?::(\d{2}))?)?',
    ).firstMatch(raw.trim());
    if (match == null) return null;
    return DateTime(
      int.parse(match.group(3)!),
      int.parse(match.group(2)!),
      int.parse(match.group(1)!),
      int.tryParse(match.group(4) ?? '') ?? 0,
      int.tryParse(match.group(5) ?? '') ?? 0,
      int.tryParse(match.group(6) ?? '') ?? 0,
    );
  }
}
