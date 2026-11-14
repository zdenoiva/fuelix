import 'dart:convert';

/// Values read from a receipt QR code or receipt text.
class ReceiptData {
  const ReceiptData({
    this.liters,
    this.total,
    this.pricePerLiter,
    this.stationName,
    this.raw,
    this.requiresOnline = false,
  });

  final double? liters;
  final double? total;
  final double? pricePerLiter;
  final String? stationName;
  final String? raw;

  /// True when the QR only carries an eKasa receipt id that would have to be
  /// resolved through the financial administration API.
  final bool requiresOnline;

  bool get hasValues => liters != null || total != null || pricePerLiter != null;

  ReceiptData copyWith({
    double? liters,
    double? total,
    double? pricePerLiter,
    String? stationName,
  }) => ReceiptData(
    liters: liters ?? this.liters,
    total: total ?? this.total,
    pricePerLiter: pricePerLiter ?? this.pricePerLiter,
    stationName: stationName ?? this.stationName,
    raw: raw,
    requiresOnline: requiresOnline,
  );
}

/// Parses the payload of a receipt QR code.
///
/// Two formats are supported:
///  * a JSON/query-string payload that contains `liters`, `total`, `price`;
///  * plain receipt text (offline fallback) where numbers are found next to
///    units and keywords such as "Spolu" or "Celkom".
class ReceiptParser {
  const ReceiptParser._();

  static ReceiptData? parse(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;

    final fromJson = _tryJson(text);
    if (fromJson != null && fromJson.hasValues) return fromJson;

    final fromQuery = _tryQuery(text);
    if (fromQuery != null && fromQuery.hasValues) return fromQuery;

    if (_isEkasa(text)) {
      final total = _valueFor(text, const ['tk', 'total', 'suma', 'sum']);
      if (total != null) {
        return ReceiptData(
          total: total,
          raw: text,
          requiresOnline: !RegExp(r'\d+[.,]?\d*\s*[lL]\b').hasMatch(text),
        );
      }
      return ReceiptData(raw: text, requiresOnline: true);
    }

    final fromText = parseText(text);
    if (fromText != null) return fromText;

    return null;
  }

  static bool _isEkasa(String text) =>
      text.toLowerCase().contains('ekasa') ||
      text.contains('financnasprava.sk') ||
      text.contains('chD=') ||
      text.contains('od=');

  static ReceiptData? _tryJson(String text) {
    if (!text.startsWith('{') && !text.startsWith('[')) return null;
    try {
      final decoded = jsonDecode(text);
      if (decoded is! Map) return null;
      final map = decoded.map((key, value) => MapEntry('$key'.toLowerCase(), value));
      final liters = _asDouble(
        map['liters'] ?? map['litres'] ?? map['l'] ?? map['mnozstvo'],
      );
      final total = _asDouble(
        map['total'] ?? map['sum'] ?? map['price'] ?? map['suma'],
      );
      final price = _asDouble(
        map['priceperliter'] ??
            map['price_per_liter'] ??
            map['unitprice'] ??
            map['ppl'],
      );
      String? station = map['station']?.toString() ?? map['pumpa']?.toString();
      final resolved = _complete(liters, total, price);
      if (resolved == null) return null;
      return ReceiptData(
        liters: resolved.$1,
        total: resolved.$2,
        pricePerLiter: resolved.$3,
        stationName: station,
        raw: text,
      );
    } catch (_) {
      return null;
    }
  }

  static ReceiptData? _tryQuery(String text) {
    if (!text.contains('=') || text.contains('\n')) return null;
    try {
      final uri = Uri.parse(text.contains('://') ? text : 'https://x/?$text');
      final params = uri.queryParameters.map(
        (key, value) => MapEntry(key.toLowerCase(), value),
      );
      if (params.isEmpty) return null;
      final liters = _asDouble(
        params['liters'] ?? params['litres'] ?? params['l'],
      );
      final total = _asDouble(
        params['total'] ?? params['sum'] ?? params['tk'] ?? params['suma'],
      );
      final price = _asDouble(params['price'] ?? params['ppl'] ?? params['unitprice']);
      final resolved = _complete(liters, total, price);
      if (resolved == null) return null;
      return ReceiptData(
        liters: resolved.$1,
        total: resolved.$2,
        pricePerLiter: resolved.$3,
        stationName: params['station'] ?? params['name'],
        raw: text,
        requiresOnline: _isEkasa(text) && liters == null,
      );
    } catch (_) {
      return null;
    }
  }

  /// Parses recognised receipt text (camera OCR) into editable values.
  ///
  /// Tuned for Slovak and Czech fuel receipts: "46.190 L", "1.624 Eur/L",
  /// "Cena celkom: 75.01 EUR".
  static ReceiptData? parseText(String text) {
    if (text.length < 8) return null;
    final lower = text.toLowerCase();

    double? liters;
    final literMatches = RegExp(
      r'(\d+[.,]\d{1,3})\s*(?:l|L|lt|litre|liter)\b',
    ).allMatches(text);
    for (final match in literMatches) {
      final value = _asDouble(match.group(1));
      if (value != null && value > 1 && value < 200) {
        liters = value;
        break;
      }
    }
    if (liters == null) {
      // Some printers drop the decimals; "46 L" is still a believable volume.
      final plain = RegExp(
        r'\b(\d{2,3})\s*(?:l|L|lt)\b',
      ).allMatches(text);
      for (final match in plain) {
        final value = _asDouble(match.group(1));
        if (value != null && value > 3 && value < 150) {
          liters = value;
          break;
        }
      }
    }

    double? price;
    final priceMatch = RegExp(
      r'(\d+[.,]\d{2,4})\s*(?:€|eur|kč|czk)?\s*/\s*(?:l|L)\b',
      caseSensitive: false,
    ).firstMatch(text);
    if (priceMatch != null) price = _asDouble(priceMatch.group(1));

    // The receipt total: prefer an amount that matches litres × unit price,
    // because OCR often reorders columns and "Spolu" is then the tax base.
    final keywordTotal = _keywordTotal(text) ??
        _valueFor(text, const ['sum', 'total']);
    double? total = keywordTotal;
    if (liters != null && price != null) {
      final expected = liters * price;
      final tolerance = expected * 0.02 + 0.05;
      double? close;
      for (final amount in _allAmounts(text)) {
        if ((amount - expected).abs() <= tolerance) {
          close = amount;
          break;
        }
      }
      total = close ?? total ?? expected;
    }

    String? station;
    for (final brand in const [
      'Slovnaft',
      'OMV',
      'Shell',
      'MOL',
      'Jurki',
      'Tesco',
      'Lukoil',
      'Orlen',
      'Benzina',
      'EuroOil',
    ]) {
      if (lower.contains(brand.toLowerCase())) {
        station = brand;
        break;
      }
    }

    final resolved = _complete(liters, total, price);
    if (resolved == null) return null;
    return ReceiptData(
      liters: resolved.$1,
      total: resolved.$2,
      pricePerLiter: resolved.$3,
      stationName: station,
      raw: text,
    );
  }

  static (double?, double?, double?)? _complete(
    double? liters,
    double? total,
    double? price,
  ) {
    var l = liters;
    var t = total;
    var p = price;
    if (t == null && l != null && p != null) t = l * p;
    if (p == null && l != null && t != null && l > 0) p = t / l;
    if (l == null && t != null && p != null && p > 0) l = t / p;
    if (l == null && t == null && p == null) return null;
    return (l, t, p);
  }

  /// All amounts with two decimals ("75.01", "60,98"), in text order.
  static List<double> _allAmounts(String text) {
    final result = <double>[];
    for (final match in RegExp(
      r'(?<!\d)(\d{1,4}[.,]\d{2})(?!\d)',
    ).allMatches(text)) {
      final value = _asDouble(match.group(1));
      if (value != null) result.add(value);
    }
    return result;
  }

  /// Amount that follows a total-ish keyword, looking up to two lines below
  /// because OCR often splits a receipt into columns.
  static double? _keywordTotal(String text) {
    final lines = text.split('\n');
    const keywords = [
      'cena celkom',
      'celkom',
      'celkem',
      'spolu',
      'suma',
      'total',
      'k úhrade',
      'uhrada',
      'zaplatíte',
    ];
    for (var index = 0; index < lines.length; index++) {
      final line = lines[index].toLowerCase();
      if (!keywords.any(line.contains)) continue;
      for (
        var offset = 0;
        offset <= 2 && index + offset < lines.length;
        offset++
      ) {
        final match = RegExp(
          r'(?<!\d)(\d+[.,]\d{1,2})(?!\d)',
        ).firstMatch(lines[index + offset]);
        if (match != null) return _asDouble(match.group(1));
      }
    }
    return null;
  }

  static double? _valueFor(String text, List<String> keys) {
    for (final key in keys) {
      final match = RegExp(
        '$key[\\s:=]*([0-9]+[.,][0-9]{1,2})',
        caseSensitive: false,
      ).firstMatch(text);
      if (match != null) return _asDouble(match.group(1));
    }
    return null;
  }

  static double? _asDouble(Object? value) {
    if (value == null) return null;
    final text = value.toString().replaceAll(',', '.').replaceAll(' ', '');
    return double.tryParse(text);
  }
}
