import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';

/// Shown instead of scene content when `GET /scenes/:id` refuses with
/// `402 scene_locked`. If [costDiamonds] is null (the screen was reached
/// without going through story_detail, which is the only place that knows
/// the cost ahead of time — see `ScenePlayerArgs`), this still gives the
/// player a way out rather than being stuck on a priceless paywall.
class UnlockScenePrompt extends StatelessWidget {
  const UnlockScenePrompt({super.key, required this.costDiamonds, required this.isUnlocking, required this.onUnlock, required this.onBack});

  final int? costDiamonds;
  final bool isUnlocking;
  final VoidCallback onUnlock;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.lock, size: 40, color: colors.textMuted),
            const SizedBox(height: 16),
            Text('scenePlayer.unlockChapter'.tr(), style: textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            if (costDiamonds != null)
              ElevatedButton(
                onPressed: isUnlocking ? null : onUnlock,
                child: isUnlocking
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text('scenePlayer.unlockChapterCost'.tr(args: ['$costDiamonds'])),
              )
            else
              OutlinedButton(onPressed: onBack, child: Text('common.back'.tr())),
          ],
        ),
      ),
    );
  }
}
