import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Renders a character in the scene player. The only implementation today
/// is [ImageCharacterSprite] (a static image, or a placeholder silhouette
/// when there's no art URL — the backend currently has no `characters`
/// table at all, so this is always the placeholder branch today; see
/// README "known limitations"); a future Rive-based implementation can be
/// swapped in without touching `scene_player_screen.dart`, since callers
/// only ever depend on this interface.
abstract class CharacterSprite {
  Widget build(BuildContext context);
}

class ImageCharacterSprite implements CharacterSprite {
  const ImageCharacterSprite({this.imageUrl});

  /// Always null today — kept so this class works unmodified once the
  /// backend exposes a real character-art URL.
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return Center(
        child: Container(
          width: 160,
          height: 280,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(LucideIcons.user, size: 64, color: Colors.white70),
        ),
      );
    }
    return Image.network(imageUrl!, fit: BoxFit.contain);
  }
}
