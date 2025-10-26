// AppColors - Centralized design token colors for FOODEx, mapped to legacy TColor
import 'package:flutter/material.dart';
import 'color_extension.dart' as legacy;

class AppColors {
  // Base palette
  static Color get primary => legacy.TColor.primary;
  static Color get secondary => legacy.TColor.secondary;
  static Color get accent => legacy.TColor.accent;
  static Color get background => legacy.TColor.background;
  static Color get cardShadow => legacy.TColor.cardShadow;

  // Text
  static Color get textPrimary => legacy.TColor.primaryText;
  static Color get textSecondary => legacy.TColor.secondaryText;
  static Color get placeholder => legacy.TColor.placeholder;

  // Feedback
  static Color get success => legacy.TColor.success;
  static Color get warning => legacy.TColor.warning;
  static Color get error => legacy.TColor.error;

  // Surfaces
  static Color get surface => Colors.white;
}
