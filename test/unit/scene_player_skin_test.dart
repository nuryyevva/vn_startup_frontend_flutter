import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nocturne/core/theme/app_colors.dart';
import 'package:nocturne/core/theme/app_theme.dart';
import 'package:nocturne/features/scene_player/presentation/theme/scene_player_skin.dart';

void main() {
  final colors = AppTheme.dark().extension<AppColors>()!;

  test('no theme gives the app look', () {
    final skin = ScenePlayerSkin.resolve(colors, null);

    expect(skin.layout, SkinLayout.sheet);
    expect(skin.panelColor, colors.surface);
    expect(skin.accentColor, colors.accent);
    expect(skin.choiceColor, isNull);
    expect(skin.font, isNull);
  });

  test('a preset is applied, and the story can override single tokens', () {
    final skin = ScenePlayerSkin.resolve(colors, {'preset': 'mist', 'accent_color': '#C9A0DC', 'panel_radius': 4});

    expect(skin.layout, SkinLayout.floating);
    expect(skin.font, 'Cormorant Garamond');
    expect(skin.accentColor, const Color(0xFFC9A0DC));
    expect(skin.panelRadius, 4);
    // Untouched preset tokens survive the override.
    expect(skin.textColor, const Color(0xFFE8EFF4));
    expect(skin.choiceBorderColor, const Color(0x739FC3D9));
  });

  test('unknown presets, unknown tokens and malformed values fall back instead of failing', () {
    final skin = ScenePlayerSkin.resolve(colors, {
      'preset': 'from-a-newer-app',
      'text_color': 'red',
      'panel_opacity': 7,
      'layout': 'sideways',
      'some_future_token': true,
    });

    expect(skin.textColor, colors.textPrimary);
    expect(skin.panelOpacity, 1);
    expect(skin.layout, SkinLayout.sheet);
  });

  test('every preset only uses tokens the skin understands', () {
    final base = ScenePlayerSkin.resolve(colors, null);
    for (final entry in scenePlayerSkinPresets.entries) {
      final skin = ScenePlayerSkin.resolve(colors, {'preset': entry.key});
      // A typo in a colour would silently keep the app's value.
      expect(skin.panelColor, isNot(base.panelColor), reason: entry.key);
      expect(skin.textColor, isNot(base.textColor), reason: entry.key);
      expect(skin.choiceColor, isNotNull, reason: entry.key);
    }
  });
}
