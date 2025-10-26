// AppTextStyles - Centralized text styles using Poppins with safe fallbacks.
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String primaryFont = 'Poppins';
  static const String fallbackFont = 'Metropolis';

  static TextStyle get h1 => const TextStyle(
        fontFamily: primaryFont,
        package: null,
        fontSize: 28,
        height: 1.2,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get h2 => const TextStyle(
        fontFamily: primaryFont,
        fontSize: 22,
        height: 1.2,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get subtitle => TextStyle(
        fontFamily: primaryFont,
        fontSize: 16,
        height: 1.3,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get body => TextStyle(
        fontFamily: primaryFont,
        fontSize: 14,
        height: 1.4,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get caption => TextStyle(
        fontFamily: primaryFont,
        fontSize: 12,
        height: 1.3,
        color: AppColors.textSecondary,
      );
}
