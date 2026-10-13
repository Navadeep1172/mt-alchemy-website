import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// MT Alchemy brand palette: warm ivory canvas, forest green and terracotta
/// clay. Deliberately no blue: green carries the human, grounded consultancy
/// voice, clay marks the moments that need action, and sage keeps secondary
/// detail quiet.
class Brand {
  /// Deep forest - dark bands, footer, CTA panel.
  static const forestDark = Color(0xFF1E3226);

  /// Primary brand colour - headings, primary surfaces, primary buttons.
  static const green = Color(0xFF2F6B4F);

  /// Darker green for hover states.
  static const greenDeep = Color(0xFF24523C);

  /// Lighter green for gradients and supporting surfaces.
  static const greenLight = Color(0xFF4C8F6B);

  /// Accent clay - calls to action and the alchemy spark.
  static const clay = Color(0xFFC97B4A);

  /// Deeper clay for hover states and fills that carry ivory text.
  static const clayDeep = Color(0xFFA8542E);

  /// Secondary accent - muted sage for progress and detail.
  static const sage = Color(0xFF7E9B87);
  static const sageLight = Color(0xFFA8C0AE);

  /// Pale sage wash for tinted panels.
  static const sageTint = Color(0xFFEDF3EC);

  /// Warm neutral surfaces.
  static const mist = Color(0xFFF8F5EF);
  static const paper = Color(0xFFFCFAF6);
  static const ink = Color(0xFF22221E);
  static const grey = Color(0xFF6B6A63);
  static const line = Color(0xFFE6E1D7);
  static const success = Color(0xFF2E9E6B);
}

/// Headings use a warm serif so the platform feels human-centred, not corporate-cold.
TextStyle heading(double size,
        {Color color = Brand.green,
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
    seedColor: Brand.green,
    primary: Brand.green,
    secondary: Brand.clay,
    tertiary: Brand.sage,
    surface: Colors.white,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Brand.paper,
  );

  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme)
        .apply(bodyColor: Brand.ink, displayColor: Brand.green),
    // Light, airy app bar with a hairline rule instead of a heavy dark slab.
    appBarTheme: const AppBarTheme(
      backgroundColor: Brand.paper,
      foregroundColor: Brand.ink,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      shape: Border(bottom: BorderSide(color: Brand.line)),
    ),
    // Buttons animate their colour, elevation and border on hover/focus so
    // every interaction in the prototype gives live feedback.
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 200),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return Brand.greenDeep;
          }
          if (states.contains(WidgetState.pressed)) return Brand.forestDark;
          return Brand.green;
        }),
        foregroundColor: const WidgetStatePropertyAll(Color(0xFFF7F4EC)),
        padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 24, vertical: 18)),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        elevation: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.hovered) ? 2 : 0),
        shadowColor: const WidgetStatePropertyAll(Color(0x332A2A24)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        animationDuration: const Duration(milliseconds: 200),
        foregroundColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.hovered)
                ? Brand.greenDeep
                : Brand.ink),
        backgroundColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.hovered)
                ? Brand.sageTint
                : Colors.transparent),
        side: WidgetStateProperty.resolveWith((states) => BorderSide(
            color: states.contains(WidgetState.hovered)
                ? Brand.greenDeep
                : Brand.ink,
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
                ? Brand.clayDeep
                : Brand.green),
        textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Brand.clayDeep,
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
          borderSide: const BorderSide(color: Brand.green, width: 1.8)),
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
          color: Brand.green, fontWeight: FontWeight.w600),
    ),
  );
}
