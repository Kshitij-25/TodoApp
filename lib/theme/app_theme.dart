import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        error: AppColors.danger,
        onSecondary: Colors.white,
        onSurface: AppColors.neutral800,
      ),
      scaffoldBackgroundColor: AppColors.neutral50,
      textTheme: TextTheme(
        displayLarge: AppTypography.display,
        headlineLarge: AppTypography.heading1,
        headlineMedium: AppTypography.heading2,
        bodyLarge: AppTypography.body,
        bodySmall: AppTypography.caption,
        labelLarge: AppTypography.label,
      ),
      dividerColor: AppColors.neutral200,
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.darkSurface,
        error: AppColors.danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.neutral50,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: TextTheme(
        displayLarge:
            AppTypography.display.copyWith(color: AppColors.neutral50),
        headlineLarge:
            AppTypography.heading1.copyWith(color: AppColors.neutral50),
        headlineMedium:
            AppTypography.heading2.copyWith(color: AppColors.neutral50),
        bodyLarge: AppTypography.body.copyWith(color: AppColors.neutral200),
        bodySmall: AppTypography.caption.copyWith(color: AppColors.neutral400),
        labelLarge: AppTypography.label.copyWith(color: AppColors.neutral200),
      ),
      dividerColor: AppColors.darkBorder,
    );
  }
}
