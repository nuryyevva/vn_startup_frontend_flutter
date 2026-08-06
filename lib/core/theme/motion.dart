import 'package:flutter/animation.dart';

/// Single place for animation durations/curves so every screen's
/// transitions feel like one system instead of N ad-hoc guesses.
abstract final class Motion {
  /// Button/card press feedback, nav indicator sliding, small state flips.
  static const microDuration = Duration(milliseconds: 200);

  /// Screen-level transitions: theme crossfade, route push/pop, Hero.
  static const screenDuration = Duration(milliseconds: 350);

  /// Staggered list entrance (catalog cards, genre chips, bundle grid).
  static const staggerStep = Duration(milliseconds: 40);
  static const staggerItemDuration = Duration(milliseconds: 300);

  static const microCurve = Curves.easeOutCubic;
  static const screenCurve = Curves.easeOutCubic;

  /// Scale target for the press-down tactile feedback on tappable cards.
  static const pressedScale = 0.97;
}
