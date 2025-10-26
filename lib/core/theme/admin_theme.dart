// Admin Theme configuration for web-specific Admin area.
import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData buildAdminTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColors.primary,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
  );
  return base.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    navigationRailTheme: const NavigationRailThemeData(
      groupAlignment: -1.0,
    ),
  );
}
