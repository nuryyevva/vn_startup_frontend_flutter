import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/genres.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../../../../core/widgets/image_placeholder.dart';
import '../../../../core/widgets/pressable_scale.dart';
import '../../domain/models/story.dart';

/// A story's cover + title + metadata, used by both the catalog grid and
/// the profile screen's compact "My Library" grid. `GET /stories` only
/// returns id/title/description/cover_url/genre/status/created_at — no
/// chapter count or rating — so the metadata line is genre-only; showing
/// "N ch · ★rating" here would mean inventing numbers the backend never
/// sent (see project spec §8.2).
class StoryCard extends StatelessWidget {
  const StoryCard({
    super.key,
    required this.story,
    this.progress,
    this.onTap,
    this.compact = false,
    this.isBookmarked,
    this.onBookmarkTap,
  });

  final Story story;

  /// Non-null only if the player has started this story — drives the
  /// Ongoing/Completed reading-status badge. Not shown when null (an
  /// unstarted story gets no badge at all, per spec §8.2).
  final ProgressSummary? progress;
  final VoidCallback? onTap;
  final bool compact;

  /// Null hides the bookmark icon entirely (used in the compact "My
  /// Library" grid, where every card is already in the library).
  final bool? isBookmarked;
  final VoidCallback? onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return PressableScale(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'story-cover-${story.id}',
                  child: RemoteImage(
                    url: story.coverUrl,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                if (story.comingSoon) ...[
                  // Dimmed, still recognisable: it's on its way, not gone.
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const Positioned(top: 8, left: 8, child: _ComingSoonBadge()),
                ] else if (progress != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _StatusBadge(isFinished: progress!.isFinished),
                  ),
                if (isBookmarked != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colors.surfaceElevated.withValues(alpha: 0.85),
                        shape: BoxShape.circle,
                      ),
                      child: AppIconButton(
                        icon: isBookmarked! ? LucideIcons.bookmarkCheck : LucideIcons.bookmark,
                        onTap: onBookmarkTap,
                        size: 16,
                        color: isBookmarked! ? context.colors.accent : context.colors.textPrimary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            story.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: compact ? textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600) : textTheme.titleMedium,
          ),
          if (!compact) ...[
            const SizedBox(height: 2),
            Text(genreLabelKeyFor(story.genre).tr(), style: textTheme.labelMedium?.copyWith(color: colors.textMuted)),
          ],
        ],
      ),
    );
  }
}

class _ComingSoonBadge extends StatelessWidget {
  const _ComingSoonBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: colors.surfaceElevated.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.sparkles, size: 12, color: colors.accent),
          const SizedBox(width: 4),
          Text(
            'stories.comingSoon'.tr(),
            style: textTheme.labelSmall?.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isFinished});

  final bool isFinished;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: colors.surfaceElevated.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(8)),
      child: Text(
        (isFinished ? 'stories.completed' : 'stories.ongoing').tr(),
        style: textTheme.labelSmall?.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w600),
      ),
    );
  }
}
