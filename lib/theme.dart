import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// MT Alchemy brand palette.
/// Visual direction required by the brief: Deep Blue, Soft Yellow and Purple.
class Brand {
  static const deepBlue = Color(0xFF1B2A4A);
  static const deepBlueDark = Color(0xFF101B31);
  static const deepBlueLight = Color(0xFF2E4470);
  static const softYellow = Color(0xFFFFD166);
  static const softYellowDeep = Color(0xFFF2B705);
  static const purple = Color(0xFF6C4AB6);
  static const purpleLight = Color(0xFF9B7EDE);
  static const lavender = Color(0xFFF4F1FB);
  static const mist = Color(0xFFF7F8FC);
  static const ink = Color(0xFF1F2430);
  static const grey = Color(0xFF5C6470);
  static const line = Color(0xFFE3E6EF);
  static const success = Color(0xFF2E9E6B);
}

/// Headings use a warm serif so the platform feels human-centred, not corporate-cold.
TextStyle heading(double size,
        {Color color = Brand.deepBlue,
        FontWeight weight = FontWeight.w600,
        double height = 1.15}) =>
    GoogleFonts.fraunces(
        fontSize: size, color: color, fontWeight: weight, height: height);

/// Body copy.
TextStyle body(double size,
        {Color color = Brand.ink,
        FontWeight weight = FontWeight.w400,
        double height = 1.6}) =>
    GoogleFonts.inter(
        fontSize: size, color: color, fontWeight: weight, height: height);

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: Brand.deepBlue,
    primary: Brand.deepBlue,
    secondary: Brand.softYellow,
    tertiary: Brand.purple,
    surface: Colors.white,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.white,
  );

  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme)
        .apply(bodyColor: Brand.ink, displayColor: Brand.deepBlue),
    appBarTheme: const AppBarTheme(
      backgroundColor: Brand.deepBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Brand.softYellow,
        foregroundColor: Brand.deepBlue,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Brand.deepBlue,
        side: const BorderSide(color: Brand.deepBlue, width: 1.4),
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Brand.line)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Brand.line)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Brand.purple, width: 1.8)),
      labelStyle: const TextStyle(color: Brand.grey),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Brand.line)),
    ),
    chipTheme: base.chipTheme.copyWith(
      labelStyle: const TextStyle(
          color: Brand.deepBlue, fontWeight: FontWeight.w600),
    ),
  );
}
