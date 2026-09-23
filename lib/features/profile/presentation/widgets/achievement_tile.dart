import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../achievements/domain/models/achievement.dart';

/// One row of the profile screen's achievements list: trophy (unlocked) or
/// lock (not yet) icon, title, description. Achievement content itself
/// (title/description per id) comes entirely from the backend catalog — see
/// `internal/achievement/catalog.go` — this widget only renders it.
class AchievementTile extends StatelessWidget {
  const AchievementTile({super.key, required this.achievement});

  final Achievement achievement;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final unlocked = achievement.unlocked;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: unlocked ? colors.accent.withValues(alpha: 0.15) : colors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: unlocked ? colors.accent : colors.border),
            ),
            child: Icon(
              unlocked ? LucideIcons.trophy : LucideIcons.lock,
              size: 18,
              color: unlocked ? colors.accent : colors.textMuted,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: textTheme.bodyLarge?.copyWith(color: unlocked ? null : colors.textMuted),
                ),
                const SizedBox(height: 2),
                Text(achievement.description, style: textTheme.labelMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
