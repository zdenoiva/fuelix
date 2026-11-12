import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/database.dart';
import '../data/repository.dart';

/// Global app state: database handle, language and theme.
class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  late final AppDatabase db;
  late final FuelixRepository repo;

  bool ready = false;
  Locale locale = const Locale('sk');
  ThemeMode themeMode = ThemeMode.system;
  String currency = 'EUR';
  String distanceUnit = 'km';

  static const _kLocale = 'locale';
  static const _kTheme = 'theme';
  static const _kCurrency = 'currency';

  Future<void> init() async {
    db = AppDatabase();
    repo = FuelixRepository(db);

    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_kLocale);
    locale = savedLocale == null
        ? const Locale('sk')
        : Locale(savedLocale);
    themeMode = switch (prefs.getString(_kTheme)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    currency = prefs.getString(_kCurrency) ?? 'EUR';
    ready = true;
    notifyListeners();
  }

  Future<void> setLocale(String code) async {
    if (locale.languageCode == code) return;
    locale = Locale(code);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocale, code);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTheme, switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    });
  }

  Future<void> setCurrency(String code) async {
    currency = code;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kCurrency, code);
  }
}
