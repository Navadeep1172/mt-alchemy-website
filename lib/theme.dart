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
    // Buttons animate their colour, elevation and border on hover/focus so
    // every interaction in the prototype gives live feedback.
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 200),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return Brand.softYellowDeep;
          }
          if (states.contains(WidgetState.pressed)) return Brand.softYellow;
          return Brand.softYellow;
        }),
        foregroundColor: const WidgetStatePropertyAll(Brand.deepBlue),
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 26, vertical: 20)),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
        textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        elevation: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.hovered) ? 9 : 0),
        shadowColor: const WidgetStatePropertyAll(Brand.softYellowDeep),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 200),
        foregroundColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.hovered)
                ? Brand.purple
                : Brand.deepBlue),
        backgroundColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.hovered)
                ? Brand.lavender
                : Colors.transparent),
        side: WidgetStateProperty.resolveWith((states) => BorderSide(
            color: states.contains(WidgetState.hovered)
                ? Brand.purple
                : Brand.deepBlue,
            width: states.contains(WidgetState.hovered) ? 1.8 : 1.4)),
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 26, vertical: 20)),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
        textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 180),
        foregroundColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.hovered)
                ? Brand.purple
                : Brand.deepBlue),
        textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Brand.purple,
      foregroundColor: Colors.white,
      elevation: 4,
      focusElevation: 8,
      hoverElevation: 10,
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
