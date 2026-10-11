import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/image_placeholder.dart';
import '../../../../core/widgets/pressable_scale.dart';
import '../../domain/models/story.dart';

/// Cover + title + thin progress bar + "N% complete" — the horizontal
/// "Continue Reading" rail's card (project spec §8.2). Distinct from
/// [StoryCard]: this one always has progress data by construction (only
/// ever built from a [ProgressSummary]).
class ContinueReadingCard extends StatelessWidget {
  const ContinueReadingCard({super.key, required this.progress, this.onTap});

  final ProgressSummary progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    final percent = progress.percentComplete;

    return SizedBox(
      width: 140,
      child: PressableScale(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              // No Hero here: the same story also sits in the catalog grid
              // below with the 'story-cover-<id>' tag, and two heroes with
              // one tag on a screen throw as soon as a route is pushed.
              child: RemoteImage(url: progress.story.coverUrl, borderRadius: BorderRadius.circular(16)),
            ),
            const SizedBox(height: 8),
            Text(
              progress.story.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: percent / 100, minHeight: 4, backgroundColor: colors.border),
            ),
            const SizedBox(height: 4),
            Text('stories.complete'.tr(args: ['$percent']), style: textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
