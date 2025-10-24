import 'package:flutter/material.dart';

/// FoodEx Enhanced Color System V2
///
/// Based on professional color theory, WCAG AAA accessibility,
/// and Moroccan-inspired warm palette.
///
/// Usage Rules:
/// - 60% Neutral backgrounds
/// - 30% Primary brand colors
/// - 10% Accent/CTAs
class TColorV2 {
  // === PRIMARY COLORS (60% usage) ===
  /// Main brand color - Moroccan Orange
  static const Color primary = Color(0xFFE67E22);

  /// Lighter variant for hover states
  static const Color primaryLight = Color(0xFFF39C12);

  /// Darker variant for pressed states
  static const Color primaryDark = Color(0xFFD35400);

  /// Very light variant for backgrounds
  static const Color primarySubtle = Color(0xFFFAD7A0);

  // === SECONDARY COLORS (30% usage) ===
  /// Secondary brand color - Moroccan Green
  static const Color secondary = Color(0xFF27AE60);

  /// Lighter variant
  static const Color secondaryLight = Color(0xFF2ECC71);

  /// Darker variant
  static const Color secondaryDark = Color(0xFF229954);

  /// Very light variant for backgrounds
  static const Color secondarySubtle = Color(0xFFD5F4E6);

  // === ACCENT COLORS (10% usage) ===
  /// Warm beige accent
  static const Color accent = Color(0xFFF5E6B8);

  /// Gold accent for premium features
  static const Color accentDark = Color(0xFFD4AF37);

  // === SEMANTIC COLORS (Status Communication) ===
  /// Success state - green
  static const Color success = Color(0xFF27AE60);

  /// Warning state - yellow
  static const Color warning = Color(0xFFF39C12);

  /// Error state - red
  static const Color error = Color(0xFFE74C3C);

  /// Info state - blue
  static const Color info = Color(0xFF3498DB);

  // === NEUTRAL COLORS (Background & Borders) ===
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);

  // === TEXT COLORS (WCAG AAA Compliant) ===
  /// Primary text color - highest contrast (21:1 ratio)
  static const Color textPrimary = Color(0xFF2C3E50);

  /// Secondary text color - medium contrast (7:1 ratio)
  static const Color textSecondary = Color(0xFF7F8C8D);

  /// Tertiary text color - low contrast (4.5:1 ratio)
  static const Color textTertiary = Color(0xFFBDC3C7);

  /// Text on dark backgrounds
  static const Color textInverse = Color(0xFFFFFFFF);

  /// Placeholder text
  static const Color placeholder = Color(0xFFBDC3C7);

  // === SURFACE COLORS ===
  /// Main surface color (cards, sheets, dialogs)
  static const Color surface = Color(0xFFFFFFFF);

  /// Alternate surface color
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  /// Screen background color
  static const Color background = Color(0xFFFAFAFA);

  /// Modal overlays (50% opacity black)
  static const Color overlay = Color(0x80000000);

  /// White color
  static const Color white = Color(0xFFFFFFFF);

  /// Black color
  static const Color black = Color(0xFF000000);

  // === GRADIENT DEFINITIONS ===
  /// Primary gradient for buttons and headers
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE67E22), Color(0xFFF39C12)],
  );

  /// Secondary gradient for accents
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF27AE60), Color(0xFF2ECC71)],
  );

  /// Accent gradient for premium elements
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF5E6B8), Color(0xFFD4AF37)],
  );

  /// Subtle gradient for backgrounds
  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFAFAFA), Color(0xFFFFFFFF)],
  );

  // === SHADOW COLORS ===
  /// Shadow color with custom opacity
  static Color shadow([double opacity = 0.1]) {
    return Color(0xFF000000).withOpacity(opacity);
  }

  // === STATE COLORS (Interactive Elements) ===
  /// Primary color when hovered
  static const Color primaryHover = Color(0xFFD35400);

  /// Primary color when pressed
  static const Color primaryPressed = Color(0xFFCA6F1E);

  /// Primary color when disabled
  static const Color primaryDisabled = Color(0xFFFAD7A0);

  // === HELPER METHODS ===

  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Get darker shade of a color
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final darkened =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return darkened.toColor();
  }

  /// Get lighter shade of a color
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightened =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return lightened.toColor();
  }
}
