import 'package:flutter/material.dart';

/// Design tokens for consistent spacing, border radius, and typography.
/// All screens and widgets should reference these instead of raw values.
abstract final class AppSpacing {
  // Spacing scale (4px base)
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 28;

  // Screen-level horizontal padding
  static const double screenPadding = 20;
}

abstract final class AppRadius {
  // Radius scale
  static const double sm = 14;
  static const double md = 18;
  static const double lg = 22;
  static const double xl = 28;
  static const double pill = 999;

  static BorderRadius rounded(double value) => BorderRadius.circular(value);
  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius button = BorderRadius.all(Radius.circular(md));
  static const BorderRadius chip = BorderRadius.all(Radius.circular(pill));
}

abstract final class AppTypography {
  // Display
  static const TextStyle hero = TextStyle(fontSize: 42, fontWeight: FontWeight.w900);
  static const TextStyle displayLarge = TextStyle(fontSize: 31, height: 1.1, fontWeight: FontWeight.w900);
  static const TextStyle displayMedium = TextStyle(fontSize: 27, fontWeight: FontWeight.w900);

  // Headings
  static const TextStyle headingLarge = TextStyle(fontSize: 24, fontWeight: FontWeight.w900);
  static const TextStyle headingMedium = TextStyle(fontSize: 22, fontWeight: FontWeight.w900);
  static const TextStyle headingSmall = TextStyle(fontSize: 20, fontWeight: FontWeight.w900);

  // Titles
  static const TextStyle titleLarge = TextStyle(fontSize: 19, fontWeight: FontWeight.w900);
  static const TextStyle titleMedium = TextStyle(fontSize: 18, fontWeight: FontWeight.w900);
  static const TextStyle titleSmall = TextStyle(fontSize: 17, fontWeight: FontWeight.w900);

  // Body
  static const TextStyle bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w800);
  static const TextStyle bodyMedium = TextStyle(fontSize: 15, fontWeight: FontWeight.w800);
  static const TextStyle body = TextStyle(fontSize: 16);

  // Captions
  static const TextStyle caption = TextStyle(fontSize: 13);
  static const TextStyle captionBold = TextStyle(fontSize: 13, fontWeight: FontWeight.w800);
  static const TextStyle overline = TextStyle(fontSize: 12);
  static const TextStyle overlineBold = TextStyle(fontSize: 12, fontWeight: FontWeight.w800);
  static const TextStyle micro = TextStyle(fontSize: 11, fontWeight: FontWeight.bold);

  // Price display
  static const TextStyle priceHero = TextStyle(fontSize: 38, fontWeight: FontWeight.w900);
}
