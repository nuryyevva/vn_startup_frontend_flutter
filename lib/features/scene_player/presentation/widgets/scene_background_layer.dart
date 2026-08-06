import 'package:flutter/material.dart';

import '../../../../core/theme/motion.dart';
import '../../../../core/widgets/image_placeholder.dart';

/// Full-screen background, crossfading on scene change (project spec §8.4
/// layer 1). Keyed by URL so `AnimatedSwitcher` treats a genuinely new
/// background as a new child worth fading, not every rebuild.
class SceneBackgroundLayer extends StatelessWidget {
  const SceneBackgroundLayer({super.key, required this.backgroundUrl});

  final String? backgroundUrl;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Motion.screenDuration,
      child: SizedBox.expand(
        key: ValueKey(backgroundUrl),
        child: RemoteImage(url: backgroundUrl, fit: BoxFit.cover),
      ),
    );
  }
}
