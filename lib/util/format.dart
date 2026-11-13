import 'package:intl/intl.dart';

String localeCode(String? languageCode) =>
    (languageCode == 'sk' || languageCode == 'cs') ? languageCode! : 'en';

String formatMoney(
  num value, {
  String currency = 'EUR',
  String language = 'sk',
  int decimals = 2,
}) {
  final format = NumberFormat.simpleCurrency(
    locale: localeCode(language),
    name: currency,
    decimalDigits: decimals,
  );
  return format.format(value);
}

String currencySymbol(String code) => switch (code.toUpperCase()) {
  'EUR' => '€',
  'CZK' => 'Kč',
  'USD' => '\$',
  'GBP' => '£',
  'PLN' => 'zł',
  'HUF' => 'Ft',
  'CHF' => 'CHF',
  _ => code,
};

String formatNumber(num value, {String language = 'sk', int decimals = 1}) {
  final format = NumberFormat.decimalPatternDigits(
    locale: localeCode(language),
    decimalDigits: decimals,
  );
  return format.format(value);
}

String formatDate(DateTime date, String language, {bool withTime = false}) {
  final pattern = withTime ? 'd. M. yyyy HH:mm' : 'd. M. yyyy';
  return DateFormat(pattern, localeCode(language)).format(date);
}

String formatMonth(DateTime date, String language) =>
    DateFormat.yMMM(localeCode(language)).format(date);

String formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} kB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

String isoDay(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

String slugify(String input) {
  const map = {
    'á': 'a', 'ä': 'a', 'č': 'c', 'ď': 'd', 'é': 'e', 'ě': 'e', 'í': 'i',
    'ľ': 'l', 'ĺ': 'l', 'ň': 'n', 'ó': 'o', 'ô': 'o', 'ŕ': 'r', 'ř': 'r',
    'š': 's', 'ť': 't', 'ú': 'u', 'ů': 'u', 'ý': 'y', 'ž': 'z',
  };
  final buffer = StringBuffer();
  for (final rune in input.toLowerCase().runes) {
    final char = String.fromCharCode(rune);
    buffer.write(map[char] ?? (RegExp(r'[a-z0-9]').hasMatch(char) ? char : '_'));
  }
  return buffer.toString().replaceAll(RegExp('_+'), '_');
}
