import 'package:json_annotation/json_annotation.dart';

/// How close the camera is on the character sprite (`scenes.sprite_framing`,
/// and a script line's `sprite_framing` switch — see the backend README,
/// "Кадр персонажа").
///
/// The backend only names the shot; what that means on screen (how much of
/// the image is cropped, how a switch animates) is decided by the renderer,
/// `FramedCharacterImage`.
enum SpriteFraming {
  /// The whole figure.
  @JsonValue('full')
  full,

  /// A closer shot, cut just below the knees.
  @JsonValue('knees')
  knees;

  /// Parses a script line's `sprite_framing`. Unknown values (a shot added
  /// by a newer backend) yield null, i.e. "keep the current shot", so new
  /// content never breaks an older app.
  static SpriteFraming? tryParse(Object? raw) => switch (raw) {
    'full' => SpriteFraming.full,
    'knees' => SpriteFraming.knees,
    _ => null,
  };
}
