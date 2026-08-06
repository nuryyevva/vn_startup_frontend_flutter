import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'pressable_scale.dart';

/// The one icon-button widget used everywhere (back arrow, settings gear,
/// bookmark toggle, chevrons) so icon size/hit-area/tap-feedback stay
/// consistent across the app instead of each screen rolling its own
/// `IconButton`.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 24,
    this.color,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return PressableScale(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: size, color: color ?? colors.textPrimary, semanticLabel: semanticLabel),
      ),
    );
  }
}
