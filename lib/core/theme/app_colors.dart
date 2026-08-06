import 'package:flutter/material.dart';

/// Color roles that don't map cleanly onto Material's [ColorScheme] — the
/// diamond/accent color, card-on-card elevation, muted placeholder text,
/// and the scrim over a locked chapter. Every screen should pull colors
/// from `Theme.of(context).extension<AppColors>()!`, never a literal hex
/// value or a bare `Colors.*` constant.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.accentMuted,
    required this.success,
    required this.warning,
    required this.error,
    required this.lockOverlay,
  });

  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color accentMuted;
  final Color success;
  final Color warning;
  final Color error;
  final Color lockOverlay;

  static const dark = AppColors(
    background: Color(0xFF0B0A16),
    surface: Color(0xFF16152A),
    surfaceElevated: Color(0xFF1F1E37),
    border: Color(0xFF2C2A47),
    textPrimary: Color(0xFFF4F3FA),
    textSecondary: Color(0xFF9B98B5),
    textMuted: Color(0xFF6C6986),
    accent: Color(0xFF8B7FF5),
    accentMuted: Color(0xFF433D75),
    success: Color(0xFF4ADE80),
    warning: Color(0xFFFBBF24),
    error: Color(0xFFF87171),
    lockOverlay: Color(0x99000000),
  );

  static const light = AppColors(
    background: Color(0xFFF8F7FC),
    surface: Color(0xFFEEECF7),
    surfaceElevated: Color(0xFFFFFFFF),
    border: Color(0xFFDCD8ED),
    textPrimary: Color(0xFF1B1930),
    textSecondary: Color(0xFF65627E),
    textMuted: Color(0xFF9895AC),
    accent: Color(0xFF7C6FE8),
    accentMuted: Color(0xFFCFC9F2),
    success: Color(0xFF16A34A),
    warning: Color(0xFFD97706),
    error: Color(0xFFDC2626),
    lockOverlay: Color(0x99000000),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accent,
    Color? accentMuted,
    Color? success,
    Color? warning,
    Color? error,
    Color? lockOverlay,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accent: accent ?? this.accent,
      accentMuted: accentMuted ?? this.accentMuted,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      lockOverlay: lockOverlay ?? this.lockOverlay,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      lockOverlay: Color.lerp(lockOverlay, other.lockOverlay, t)!,
    );
  }
}

/// Convenience accessor: `context.colors.accent` instead of the verbose
/// `Theme.of(context).extension<AppColors>()!` at every call site.
extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
