import 'package:flutter/material.dart';

const Color brandGreen = Color(0xFF0E9F6E);

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: brandGreen,
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.transparent,
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: scheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: brightness == Brightness.dark
          ? Colors.white.withValues(alpha: 0.06)
          : Colors.white.withValues(alpha: 0.55),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.primary, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      side: BorderSide(color: scheme.outlineVariant),
      backgroundColor: scheme.surfaceContainerLow,
      selectedColor: scheme.primaryContainer,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: brightness == Brightness.dark
          ? const Color(0xFF0A1812).withValues(alpha: 0.72)
          : Colors.white.withValues(alpha: 0.72),
      indicatorColor: scheme.primaryContainer.withValues(alpha: 0.85),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      height: 68,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surface.withValues(alpha: 0.96),
      surfaceTintColor: Colors.transparent,
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant.withValues(alpha: 0.5),
      thickness: 1,
      space: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

/// Accent colours used for category dots and charts.
const List<Color> chartPalette = [
  Color(0xFF0E9F6E),
  Color(0xFF3B82F6),
  Color(0xFFF59E0B),
  Color(0xFFEF4444),
  Color(0xFF8B5CF6),
  Color(0xFF14B8A6),
  Color(0xFFEC4899),
  Color(0xFF64748B),
];
