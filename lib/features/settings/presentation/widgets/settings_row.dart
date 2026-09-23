import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/pressable_scale.dart';

/// One tappable row inside a settings section: label, optional subtitle,
/// optional trailing value, chevron. Used for Account/About rows that
/// navigate or open something.
class SettingsRow extends StatelessWidget {
  const SettingsRow({super.key, required this.label, this.subtitle, this.trailingText, this.onTap});

  final String label;
  final String? subtitle;
  final String? trailingText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    return PressableScale(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: textTheme.bodyLarge),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: textTheme.labelMedium),
                  ],
                ],
              ),
            ),
            if (trailingText != null) ...[
              Flexible(
                child: Text(
                  trailingText!,
                  style: textTheme.bodyMedium?.copyWith(color: colors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (onTap != null) Icon(LucideIcons.chevronRight, size: 20, color: colors.textMuted),
          ],
        ),
      ),
    );
  }
}

/// A row with a trailing [Switch] — for Notifications toggles.
class SettingsSwitchRow extends StatelessWidget {
  const SettingsSwitchRow({super.key, required this.label, required this.subtitle, required this.value, required this.onChanged});

  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.bodyLarge),
                const SizedBox(height: 2),
                Text(subtitle, style: textTheme.labelMedium),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
