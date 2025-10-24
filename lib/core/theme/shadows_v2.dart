import 'package:flutter/material.dart';
import 'color_system_v2.dart';

/// FoodEx Shadow System V2
///
/// Material Design 3 elevation levels with consistent shadows
/// for depth perception and visual hierarchy.
class ShadowsV2 {
  // === ELEVATION LEVELS ===

  /// Level 0 - No shadow (flat surface)
  static List<BoxShadow> get none => [];

  /// Level 1 - Subtle elevation (1dp)
  /// Use for: Slightly raised elements
  static List<BoxShadow> get level1 => [
        BoxShadow(
          color: TColorV2.shadow(0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
          spreadRadius: 0,
        ),
      ];

  /// Level 2 - Light elevation (2dp)
  /// Use for: Cards at rest, buttons
  static List<BoxShadow> get level2 => [
        BoxShadow(
          color: TColorV2.shadow(0.08),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ];

  /// Level 3 - Medium elevation (4dp)
  /// Use for: Raised cards, hovering buttons
  static List<BoxShadow> get level3 => [
        BoxShadow(
          color: TColorV2.shadow(0.10),
          blurRadius: 8,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  /// Level 4 - High elevation (8dp)
  /// Use for: Dropdowns, pickers, menus
  static List<BoxShadow> get level4 => [
        BoxShadow(
          color: TColorV2.shadow(0.12),
          blurRadius: 16,
          offset: const Offset(0, 8),
          spreadRadius: 0,
        ),
      ];

  /// Level 5 - Higher elevation (16dp)
  /// Use for: Navigation drawer, floating action button
  static List<BoxShadow> get level5 => [
        BoxShadow(
          color: TColorV2.shadow(0.15),
          blurRadius: 24,
          offset: const Offset(0, 12),
          spreadRadius: 0,
        ),
      ];

  /// Level 6 - Highest elevation (24dp)
  /// Use for: Dialogs, modals
  static List<BoxShadow> get level6 => [
        BoxShadow(
          color: TColorV2.shadow(0.18),
          blurRadius: 32,
          offset: const Offset(0, 16),
          spreadRadius: 0,
        ),
      ];

  // === SEMANTIC SHADOWS (Named by Purpose) ===

  /// Shadow for buttons
  static List<BoxShadow> get button => level2;

  /// Shadow for cards
  static List<BoxShadow> get card => level2;

  /// Shadow for cards on hover
  static List<BoxShadow> get cardHover => level3;

  /// Shadow for pressed cards
  static List<BoxShadow> get cardPressed => level1;

  /// Shadow for dialogs
  static List<BoxShadow> get dialog => level6;

  /// Shadow for bottom sheets
  static List<BoxShadow> get bottomSheet => level5;

  /// Shadow for navigation bar
  static List<BoxShadow> get navigationBar => level3;

  /// Shadow for floating action button
  static List<BoxShadow> get fab => level4;

  /// Shadow for app bar
  static List<BoxShadow> get appBar => level2;

  /// Shadow for chips
  static List<BoxShadow> get chip => level1;

  /// Shadow for tooltips
  static List<BoxShadow> get tooltip => level4;

  // === COLORED SHADOWS ===

  /// Primary colored shadow (for primary buttons)
  static List<BoxShadow> primaryShadow(double opacity) => [
        BoxShadow(
          color: TColorV2.primary.withOpacity(opacity * 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  /// Secondary colored shadow
  static List<BoxShadow> secondaryShadow(double opacity) => [
        BoxShadow(
          color: TColorV2.secondary.withOpacity(opacity * 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  /// Error colored shadow
  static List<BoxShadow> errorShadow(double opacity) => [
        BoxShadow(
          color: TColorV2.error.withOpacity(opacity * 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  /// Success colored shadow
  static List<BoxShadow> successShadow(double opacity) => [
        BoxShadow(
          color: TColorV2.success.withOpacity(opacity * 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  // === CUSTOM SHADOW BUILDER ===

  /// Create custom shadow with specific parameters
  static List<BoxShadow> custom({
    required Color color,
    required double blurRadius,
    required Offset offset,
    double spreadRadius = 0,
    double opacity = 1.0,
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: blurRadius,
        offset: offset,
        spreadRadius: spreadRadius,
      ),
    ];
  }

  /// Create inner shadow effect (for inputs)
  static List<BoxShadow> inner({
    Color? color,
    double blurRadius = 4,
    Offset offset = const Offset(0, 2),
  }) {
    return [
      BoxShadow(
        color: (color ?? TColorV2.black).withOpacity(0.1),
        blurRadius: blurRadius,
        offset: offset,
        spreadRadius: -2,
      ),
    ];
  }

  // === NEUMORPHIC SHADOWS ===

  /// Neumorphic light shadow (top-left)
  static BoxShadow get neumorphicLight => BoxShadow(
        color: TColorV2.white.withOpacity(0.7),
        blurRadius: 15,
        offset: const Offset(-5, -5),
      );

  /// Neumorphic dark shadow (bottom-right)
  static BoxShadow get neumorphicDark => BoxShadow(
        color: TColorV2.shadow(0.15),
        blurRadius: 15,
        offset: const Offset(5, 5),
      );

  /// Combined neumorphic effect
  static List<BoxShadow> get neumorphic => [
        neumorphicLight,
        neumorphicDark,
      ];

  // === GLOW EFFECTS ===

  /// Primary glow effect
  static List<BoxShadow> get primaryGlow => [
        BoxShadow(
          color: TColorV2.primary.withOpacity(0.4),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];

  /// Secondary glow effect
  static List<BoxShadow> get secondaryGlow => [
        BoxShadow(
          color: TColorV2.secondary.withOpacity(0.4),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];

  /// Success glow effect
  static List<BoxShadow> get successGlow => [
        BoxShadow(
          color: TColorV2.success.withOpacity(0.4),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];

  /// Error glow effect
  static List<BoxShadow> get errorGlow => [
        BoxShadow(
          color: TColorV2.error.withOpacity(0.4),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ];
}

/// Extension for easy shadow application
extension BoxDecorationX on BoxDecoration {
  /// Apply shadow to BoxDecoration
  BoxDecoration withShadow(List<BoxShadow> shadow) {
    return copyWith(boxShadow: shadow);
  }
}
