import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// MT Alchemy brand palette: deep teal with a warm amber accent.
/// Teal carries authority and calm (the consultancy voice); amber marks the
/// moments that need action; luminous aqua is reserved for progress and
/// secondary detail so the palette never feels busy.
class Brand {
  /// Deepest teal - footers, app bar, app-level ink.
  static const tealDark = Color(0xFF062A33);

  /// Primary brand colour - headings, primary surfaces.
  static const teal = Color(0xFF0E4C5C);

  /// Lighter teal for gradients and supporting surfaces.
  static const tealLight = Color(0xFF1E7585);

  /// Accent amber - calls to action and the alchemy spark.
  static const amber = Color(0xFFE8A33D);

  /// Deeper amber for hover states.
  static const amberDeep = Color(0xFFC4841D);

  /// Secondary accent - luminous aqua for progress and detail.
  static const aqua = Color(0xFF3C9AAB);
  static const aquaLight = Color(0xFF7FC7D1);

  /// Pale aqua wash for tinted panels.
  static const aquaTint = Color(0xFFEAF4F6);

  static const mist = Color(0xFFF6F9FA);
  static const ink = Color(0xFF1D2429);
  static const grey = Color(0xFF5B6871);
  static const line = Color(0xFFE1E8EA);
  static const success = Color(0xFF2E9E6B);
}

/// Headings use a warm serif so the platform feels human-centred, not corporate-cold.
TextStyle heading(double size,
        {Color color = Brand.teal,
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
    seedColor: Brand.teal,
    primary: Brand.teal,
    secondary: Brand.amber,
    tertiary: Brand.aqua,
    surface: Colors.white,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.white,
  );

  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme)
        .apply(bodyColor: Brand.ink, displayColor: Brand.teal),
    appBarTheme: const AppBarTheme(
      backgroundColor: Brand.teal,
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
            return Brand.amberDeep;
          }
          if (states.contains(WidgetState.pressed)) return Brand.amber;
          return Brand.amber;
        }),
        foregroundColor: const WidgetStatePropertyAll(Brand.tealDark),
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 18)),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        elevation: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.hovered) ? 2 : 0),
        shadowColor: const WidgetStatePropertyAll(Color(0x33062A33)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 200),
        foregroundColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.hovered)
                ? Brand.aqua
                : Brand.teal),
        backgroundColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.hovered)
                ? Brand.aquaTint
                : Colors.transparent),
        side: WidgetStateProperty.resolveWith((states) => BorderSide(
            color: states.contains(WidgetState.hovered)
                ? Brand.aqua
                : Brand.teal,
            width: states.contains(WidgetState.hovered) ? 1.8 : 1.4)),
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 18)),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 180),
        foregroundColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.hovered)
                ? Brand.aqua
                : Brand.teal),
        textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Brand.teal,
      foregroundColor: Colors.white,
      elevation: 3,
      focusElevation: 5,
      hoverElevation: 6,
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
          borderSide: const BorderSide(color: Brand.aqua, width: 1.8)),
      labelStyle: const TextStyle(color: Brand.grey),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Brand.line)),
    ),
    chipTheme: base.chipTheme.copyWith(
      labelStyle: const TextStyle(
          color: Brand.teal, fontWeight: FontWeight.w600),
    ),
  );
}
