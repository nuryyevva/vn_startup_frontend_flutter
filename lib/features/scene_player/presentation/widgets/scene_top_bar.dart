import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/widgets/app_icon_button.dart';

/// Back, message log, auto-play/skip. Auto-play and skip are visibly
/// present but disabled — not in this task's scope, but the spec is
/// explicit that placeholder buttons should stay in the layout rather
/// than silently vanish (project spec §8.4 layer 6).
class SceneTopBar extends StatelessWidget {
  const SceneTopBar({super.key, required this.onBack, required this.onShowLog});

  final VoidCallback onBack;
  final VoidCallback onShowLog;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            AppIconButton(icon: LucideIcons.arrowLeft, onTap: onBack, color: Colors.white),
            const Spacer(),
            TextButton.icon(
              onPressed: onShowLog,
              icon: const Icon(LucideIcons.history, size: 16, color: Colors.white),
              label: Text('scenePlayer.logTitle'.tr(), style: const TextStyle(color: Colors.white)),
            ),
            // TODO(scene_player): wire real auto-play/skip once pacing UX is designed.
            IconButton(
              onPressed: null,
              icon: const Icon(LucideIcons.play, color: Colors.white38),
              tooltip: 'scenePlayer.autoPlay'.tr(),
            ),
            IconButton(
              onPressed: null,
              icon: const Icon(LucideIcons.chevronsRight, color: Colors.white38),
              tooltip: 'scenePlayer.skip'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
