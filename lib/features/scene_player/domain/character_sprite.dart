import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/media/media_source.dart';

/// Renders a character in the scene player. The only implementation today
/// is [ImageCharacterSprite] (a static image, or a placeholder silhouette
/// when the scene has no `character_sprite_url` — the backend has no real
/// `characters` table, so this is a URL denormalized onto `scenes` for now,
/// see `cmd/seed`); a future Rive-based implementation can be swapped in
/// without touching `scene_player_screen.dart`, since callers only ever
/// depend on this interface.
abstract class CharacterSprite {
  Widget build(BuildContext context);
}

class ImageCharacterSprite implements CharacterSprite {
  const ImageCharacterSprite({this.imageUrl});

  /// Null falls back to a placeholder silhouette (see [build]) — most
  /// scenes with a character do set this today, but it's still optional at
  /// the data layer.
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
    return Image(image: mediaImageProvider(imageUrl!), fit: BoxFit.contain);
  }
}
