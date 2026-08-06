import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// The single font stack for the whole app (Manrope — a clean geometric
/// sans, matching the design reference) plus the type scale used across
/// every screen. Build once per theme via [AppTypography.textTheme] rather
/// than reaching for `GoogleFonts.manrope()` ad hoc in widgets.
abstract final class AppTypography {
  static TextTheme textTheme(AppColors colors) {
    final base = GoogleFonts.manropeTextTheme().apply(
      bodyColor: colors.textPrimary,
      displayColor: colors.textPrimary,
    );
    return base
        .copyWith(
          displayLarge: base.displayLarge?.copyWith(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: colors.textPrimary,
          ),
          headlineLarge: base.headlineLarge?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
          titleLarge: base.titleLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
          titleMedium: base.titleMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
          bodyLarge: base.bodyLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: colors.textPrimary,
          ),
          bodyMedium: base.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: colors.textSecondary,
          ),
          labelMedium: base.labelMedium?.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
          ),
          labelSmall: base.labelSmall?.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: colors.textMuted,
          ),
        );
  }
}
