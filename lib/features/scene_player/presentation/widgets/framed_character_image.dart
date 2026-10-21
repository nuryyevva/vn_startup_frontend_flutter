import 'package:flutter/material.dart';

import '../../../stories/domain/models/sprite_framing.dart';

/// A character sprite shown in a [SpriteFraming] shot, animating between
/// shots when the framing changes.
///
/// [SpriteFraming.full] is plain [BoxFit.contain] over the whole area, so
/// any image (including the hotlinked, non-normalized sprites of the sample
/// stories) looks exactly as it always has.
///
/// [SpriteFraming.knees] relies on the sprite convention of the story art
/// (backend README, "Кадр персонажа"): a [spriteAspectRatio] canvas with the
/// figure standing head to feet, its head [spriteHeadInset] below the top.
/// The camera moves in until the figure spans from [kneesHeadroom] below the
/// top of the area — the head in the upper part of the screen, where the eye
/// goes — down to the cut just below the knees on the bottom edge. The size
/// follows the area's height only, so a tall phone screen gets the same
/// close-up as a wide one; what doesn't fit sideways is the canvas'
/// transparent margin (very wide poses may lose a fingertip at the edges).
class FramedCharacterImage extends StatelessWidget {
  const FramedCharacterImage({super.key, required this.image, required this.framing});

  final ImageProvider image;
  final SpriteFraming framing;

  /// Width / height of a normalized sprite canvas (1024×1536).
  static const spriteAspectRatio = 2 / 3;

  /// Share of the canvas height (from the top) a [SpriteFraming.knees] shot
  /// shows: the figure spans almost the whole canvas, so this cuts it about
  /// three quarters down, just below the knees.
  static const kneesVisibleFraction = 0.75;

  /// Where the top of the head is in a normalized canvas: 40px of 1536.
  static const spriteHeadInset = 40 / 1536;

  /// Where the top of the head goes in a [SpriteFraming.knees] shot, as a
  /// share of the area height. 0.18 puts the eyes at about a quarter of the
  /// height and keeps the head clear of the scene's top bar.
  static const kneesHeadroom = 0.18;

  /// The shot change is a camera move, a bit slower than a screen change so
  /// it reads as one rather than as a jump.
  static const duration = Duration(milliseconds: 450);
  static const curve = Curves.easeInOutCubic;

  /// Where the image goes in an area of [size] at [closeness] (0 = full
  /// shot, 1 = knee shot). Between the two the rectangle is interpolated, so
  /// the move is continuous. Exposed for tests.
  static Rect imageRect(Size size, double closeness) {
    final full = Offset.zero & size;
    if (closeness <= 0) return full;

    // The visible part of the canvas, head to knees, spans from the headroom
    // line to the bottom edge.
    final height = size.height * (1 - kneesHeadroom) / (kneesVisibleFraction - spriteHeadInset);
    final width = height * spriteAspectRatio;
    final top = size.height * kneesHeadroom - height * spriteHeadInset;
    final knees = Rect.fromLTWH((size.width - width) / 2, top, width, height);
    return Rect.lerp(full, knees, closeness)!;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: framing == SpriteFraming.knees ? 1 : 0),
      duration: duration,
      curve: curve,
      child: Image(image: image, fit: BoxFit.contain),
      builder: (context, closeness, child) => LayoutBuilder(
        builder: (context, constraints) {
          final rect = imageRect(constraints.biggest, closeness);
          return ClipRect(
            child: Stack(
              children: [Positioned.fromRect(rect: rect, child: child!)],
            ),
          );
        },
      ),
    );
  }
}
