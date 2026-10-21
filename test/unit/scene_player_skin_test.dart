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
      expect(skin.talkColor, isNotNull, reason: entry.key);
      expect(skin.talkBorderColor, isNotNull, reason: entry.key);
      expect(skin.talkGlowColor, isNotNull, reason: entry.key);
    }
  });

  test('the talk option follows the accent when the theme sets no talk tokens', () {
    final skin = ScenePlayerSkin.resolve(colors, {'accent_color': '#E8C36A', 'choice_text_color': '#101010'});

    expect(skin.talkEffect, TalkEffect.shimmer);
    expect(skin.effectiveTalkBorderColor, const Color(0xFFE8C36A));
    expect(skin.effectiveTalkGlowColor.toARGB32() & 0xFFFFFF, 0xE8C36A);
    expect(skin.effectiveTalkGlowColor.a, lessThan(1));
    expect(skin.effectiveTalkTextColor, const Color(0xFF101010));
    expect(skin.effectiveTalkColor, isNot(Colors.transparent));
  });

  test('talk tokens override the preset; unknown effects keep the preset one', () {
    final skin = ScenePlayerSkin.resolve(colors, {
      'preset': 'storybook',
      'talk_border_color': '#123456',
      'talk_effect': 'fireworks',
    });

    expect(skin.effectiveTalkBorderColor, const Color(0xFF123456));
    expect(skin.talkEffect, TalkEffect.glow, reason: 'the storybook preset glows, a newer effect name is ignored');
    expect(ScenePlayerSkin.resolve(colors, {'talk_effect': 'none'}).talkEffect, TalkEffect.none);
  });
}
