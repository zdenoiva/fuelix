import 'package:flutter/material.dart';

import '../app_state.dart';
import 'format.dart';

extension ContextFormat on BuildContext {
  String get lang => Localizations.localeOf(this).languageCode;

  String money(num value, {int decimals = 2}) => formatMoney(
    value,
    currency: AppState.instance.currency,
    language: lang,
    decimals: decimals,
  );

  String roundMoney(num value) => money(value, decimals: 0);

  String num1(num value) => formatNumber(value, language: lang);

  String num2(num value) => formatNumber(value, language: lang, decimals: 2);

  String date(DateTime value) => formatDate(value, lang);

  String dateTime(DateTime value) => formatDate(value, lang, withTime: true);

  String month(DateTime value) => formatMonth(value, lang);
}
