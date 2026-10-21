import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

/// How the dialogue panel sits on the scene.
enum SkinLayout {
  /// Edge-to-edge sheet rising from the bottom (the default look).
  sheet,

  /// Inset card with margins, rounded on every corner.
  floating,
}

/// How the free-conversation option ("talk to …") draws attention to itself
/// among the scripted choices.
enum TalkEffect {
  /// A highlight runs along the outline while the glow breathes.
  shimmer,

  /// Only the glow breathes.
  glow,

  /// Static: outline and glow, no motion.
  none,
}

/// The look of the scene player's text surfaces — the dialogue box, the
/// choice buttons and the ending panel — for one story.
///
/// A skin is resolved from a story's `player_theme`: a flat map of design
/// tokens (below), all optional. `preset` names an entry of
/// [scenePlayerSkinPresets] to start from, and any other token overrides
/// it, so a story is styled with `{"preset": "mist"}` and fine-tuned with
/// e.g. `{"preset": "mist", "accent_color": "#C9A0DC"}`. No theme at all
/// gives [ScenePlayerSkin.fromAppColors] — the app's own light/dark look.
/// A preset is itself just a token map, so adding one is a few lines here
/// and needs no new widget code.
///
/// Tokens (colors are `#RRGGBB` or `#AARRGGBB`):
///
/// | token | meaning |
/// |---|---|
/// | `layout` | `sheet` or `floating` |
/// | `font`, `speaker_font` | Google Fonts family for the text / speaker name |
/// | `font_scale` | text size multiplier (some display fonts run small) |
/// | `speaker_caps` | speaker name in spaced capitals |
/// | `panel_color`, `panel_gradient_to` | panel fill; with both, a top-to-bottom gradient |
/// | `panel_opacity` | 0..1, how much of the scene shows through |
/// | `panel_blur` | blur of the scene behind the panel (frosted glass) |
/// | `panel_border_color`, `panel_border_width`, `panel_radius` | panel outline |
/// | `panel_glow_color` | soft outer glow |
/// | `text_color`, `narration_color` | speech and thoughts / narration |
/// | `accent_color` | speaker name and the thought marker |
/// | `choice_color`, `choice_border_color`, `choice_text_color`, `choice_radius` | choice buttons |
/// | `talk_color`, `talk_gradient_to` | fill of the free-conversation option; with both, a left-to-right gradient |
/// | `talk_border_color`, `talk_text_color`, `talk_glow_color` | its outline, label and glow |
/// | `talk_effect` | `shimmer`, `glow` or `none` (see [TalkEffect]) |
///
/// The talk option's tokens default to the story's accent colour and choice
/// tokens, so a theme that sets none of them still gets a matching
/// highlighted option.
///
/// Unknown tokens and malformed values are ignored rather than failing:
/// themes come from the backend, and an app build older than a theme must
/// still play the story.
@immutable
class ScenePlayerSkin extends ThemeExtension<ScenePlayerSkin> {
  const ScenePlayerSkin({
    required this.layout,
    required this.panelColor,
    required this.panelOpacity,
    required this.panelBorderColor,
    required this.panelBorderWidth,
    required this.panelRadius,
    required this.textColor,
    required this.narrationColor,
    required this.accentColor,
    this.panelGradientTo,
    this.panelBlur = 0,
    this.panelGlowColor,
    this.font,
    this.speakerFont,
    this.fontScale = 1,
    this.speakerCaps = false,
    this.choiceColor,
    this.choiceBorderColor,
    this.choiceTextColor,
    this.choiceRadius,
    this.talkColor,
    this.talkGradientTo,
    this.talkBorderColor,
    this.talkTextColor,
    this.talkGlowColor,
    this.talkEffect = TalkEffect.shimmer,
  });

  /// The app's standard look, following its light/dark palette.
  factory ScenePlayerSkin.fromAppColors(AppColors colors) => ScenePlayerSkin(
    layout: SkinLayout.sheet,
    panelColor: colors.surface,
    panelOpacity: 0.92,
    panelBorderColor: colors.border,
    panelBorderWidth: 1,
    panelRadius: 24,
    textColor: colors.textPrimary,
    narrationColor: colors.textSecondary,
    accentColor: colors.accent,
  );

  /// Resolves a story's `player_theme` on top of the app's standard look.
  factory ScenePlayerSkin.resolve(AppColors colors, Map<String, dynamic>? theme) {
    final base = ScenePlayerSkin.fromAppColors(colors);
    if (theme == null) return base;
    final preset = scenePlayerSkinPresets[theme['preset']];
    return base._apply(preset ?? const {})._apply(theme);
  }

  final SkinLayout layout;
  final Color panelColor;
  final Color? panelGradientTo;
  final double panelOpacity;
  final double panelBlur;
  final Color panelBorderColor;
  final double panelBorderWidth;
  final double panelRadius;
  final Color? panelGlowColor;
  final Color textColor;
  final Color narrationColor;
  final Color accentColor;
  final String? font;
  final String? speakerFont;
  final double fontScale;
  final bool speakerCaps;

  /// Null choice tokens leave the app's own button theme in place.
  final Color? choiceColor;
  final Color? choiceBorderColor;
  final Color? choiceTextColor;
  final double? choiceRadius;

  /// Free-conversation option. Null tokens are derived from the accent and
  /// choice tokens — use the `effectiveTalk*` getters.
  final Color? talkColor;
  final Color? talkGradientTo;
  final Color? talkBorderColor;
  final Color? talkTextColor;
  final Color? talkGlowColor;
  final TalkEffect talkEffect;

  /// Fill: a light wash of the accent over the choice fill.
  Color get effectiveTalkColor =>
      talkColor ?? Color.alphaBlend(accentColor.withValues(alpha: 0.14), choiceColor ?? Colors.transparent);

  Color get effectiveTalkBorderColor => talkBorderColor ?? accentColor;

  Color get effectiveTalkTextColor => talkTextColor ?? choiceTextColor ?? textColor;

  Color get effectiveTalkGlowColor => talkGlowColor ?? accentColor.withValues(alpha: 0.6);

  static ScenePlayerSkin of(BuildContext context) =>
      Theme.of(context).extension<ScenePlayerSkin>() ?? ScenePlayerSkin.fromAppColors(context.colors);

  /// [base] in this skin's body font and scale. Color is left to callers —
  /// speech, narration and thoughts differ.
  TextStyle? bodyStyle(TextStyle? base) => _withFont(base, font);

  TextStyle? speakerStyle(TextStyle? base) => _withFont(
    base,
    speakerFont ?? font,
  )?.copyWith(color: accentColor, fontWeight: FontWeight.w700, letterSpacing: speakerCaps ? 1.6 : null);

  TextStyle? _withFont(TextStyle? base, String? family) {
    if (base == null) return null;
    final scaled = fontScale == 1 ? base : base.copyWith(fontSize: (base.fontSize ?? 16) * fontScale);
    if (family == null) return scaled;
    try {
      return GoogleFonts.getFont(family, textStyle: scaled);
    } on Exception {
      // Not a Google Fonts family this build knows — keep the app font.
      return scaled;
    }
  }

  ScenePlayerSkin _apply(Map<String, dynamic> t) => ScenePlayerSkin(
    layout: switch (t['layout']) {
      'sheet' => SkinLayout.sheet,
      'floating' => SkinLayout.floating,
      _ => layout,
    },
    panelColor: _color(t['panel_color']) ?? panelColor,
    panelGradientTo: _color(t['panel_gradient_to']) ?? panelGradientTo,
    panelOpacity: _number(t['panel_opacity'], max: 1) ?? panelOpacity,
    panelBlur: _number(t['panel_blur'], max: 40) ?? panelBlur,
    panelBorderColor: _color(t['panel_border_color']) ?? panelBorderColor,
    panelBorderWidth: _number(t['panel_border_width'], max: 8) ?? panelBorderWidth,
    panelRadius: _number(t['panel_radius'], max: 48) ?? panelRadius,
    panelGlowColor: _color(t['panel_glow_color']) ?? panelGlowColor,
    textColor: _color(t['text_color']) ?? textColor,
    narrationColor: _color(t['narration_color']) ?? narrationColor,
    accentColor: _color(t['accent_color']) ?? accentColor,
    font: _text(t['font']) ?? font,
    speakerFont: _text(t['speaker_font']) ?? speakerFont,
    fontScale: _number(t['font_scale'], min: 0.8, max: 1.5) ?? fontScale,
    speakerCaps: t['speaker_caps'] is bool ? t['speaker_caps'] as bool : speakerCaps,
    choiceColor: _color(t['choice_color']) ?? choiceColor,
    choiceBorderColor: _color(t['choice_border_color']) ?? choiceBorderColor,
    choiceTextColor: _color(t['choice_text_color']) ?? choiceTextColor,
    choiceRadius: _number(t['choice_radius'], max: 999) ?? choiceRadius,
    talkColor: _color(t['talk_color']) ?? talkColor,
    talkGradientTo: _color(t['talk_gradient_to']) ?? talkGradientTo,
    talkBorderColor: _color(t['talk_border_color']) ?? talkBorderColor,
    talkTextColor: _color(t['talk_text_color']) ?? talkTextColor,
    talkGlowColor: _color(t['talk_glow_color']) ?? talkGlowColor,
    talkEffect: switch (t['talk_effect']) {
      'shimmer' => TalkEffect.shimmer,
      'glow' => TalkEffect.glow,
      'none' => TalkEffect.none,
      _ => talkEffect,
    },
  );

  static Color? _color(Object? raw) {
    if (raw is! String || !raw.startsWith('#')) return null;
    final hex = raw.substring(1);
    final value = int.tryParse(hex, radix: 16);
    if (value == null) return null;
    return switch (hex.length) {
      6 => Color(0xFF000000 | value),
      8 => Color(value),
      _ => null,
    };
  }

  static double? _number(Object? raw, {double min = 0, required double max}) =>
      raw is num ? raw.toDouble().clamp(min, max) : null;

  static String? _text(Object? raw) => raw is String && raw.isNotEmpty ? raw : null;

  // The skin is fixed for a story's lifetime on screen, so it's swapped,
  // not tweened.
  @override
  ScenePlayerSkin copyWith() => this;

  @override
  ScenePlayerSkin lerp(ThemeExtension<ScenePlayerSkin>? other, double t) =>
      t < 0.5 || other is! ScenePlayerSkin ? this : other;
}

/// Named starting points for a story's `player_theme` (`"preset": "<name>"`).
/// Plain token maps — the same vocabulary a story can override.
const Map<String, Map<String, dynamic>> scenePlayerSkinPresets = {
  // Fog and cold light: frosted blue-grey glass, a thin pale outline, an
  // old-book serif. Mystery, gothic romance.
  'mist': {
    'layout': 'floating',
    'font': 'Cormorant Garamond',
    'font_scale': 1.2,
    'speaker_caps': true,
    'panel_color': '#0D151E',
    'panel_gradient_to': '#1C2B39',
    'panel_opacity': 0.66,
    'panel_blur': 14,
    'panel_border_color': '#669FC3D9',
    'panel_radius': 18,
    'panel_glow_color': '#2E9FC3D9',
    'text_color': '#E8EFF4',
    'narration_color': '#AFC1CD',
    'accent_color': '#9FC3D9',
    'choice_color': '#B30F1922',
    'choice_border_color': '#739FC3D9',
    'choice_text_color': '#E8EFF4',
    'choice_radius': 12,
    // Cold moonlight running along the outline.
    'talk_color': '#D91A3042',
    'talk_gradient_to': '#D92A4A63',
    'talk_border_color': '#C9DFEC',
    'talk_text_color': '#F4F8FB',
    'talk_glow_color': '#A69FC3D9',
    'talk_effect': 'shimmer',
  },

  // A page from an illustrated fairy-tale book: parchment, ink-brown
  // text, a red initial.
  'storybook': {
    'layout': 'sheet',
    'font': 'Lora',
    'panel_color': '#F4E9D2',
    'panel_opacity': 0.96,
    'panel_border_color': '#8A5A2B',
    'panel_border_width': 2,
    'panel_radius': 10,
    'text_color': '#3A2414',
    'narration_color': '#6B4A2E',
    'accent_color': '#A8322A',
    'choice_color': '#EAD9B5',
    'choice_border_color': '#8A5A2B',
    'choice_text_color': '#3A2414',
    'choice_radius': 6,
    // Paper doesn't shine: a red-ink frame and a warm, slow glow.
    'talk_color': '#F7EBCF',
    'talk_border_color': '#A8322A',
    'talk_text_color': '#7A231D',
    'talk_glow_color': '#80C0662B',
    'talk_effect': 'glow',
  },

  // Dreamlike and theatrical: violet into teal, pill-shaped buttons.
  'wonderland': {
    'layout': 'floating',
    'font': 'Playfair Display',
    'panel_color': '#2A1442',
    'panel_gradient_to': '#0F3B45',
    'panel_opacity': 0.82,
    'panel_blur': 8,
    'panel_border_color': '#80C9A7F0',
    'panel_radius': 28,
    'text_color': '#F6F0FF',
    'narration_color': '#CDBCE4',
    'accent_color': '#C9A7F0',
    'choice_color': '#CC2E1A47',
    'choice_border_color': '#99C9A7F0',
    'choice_text_color': '#F6F0FF',
    'choice_radius': 999,
    // Iridescent: the violet-to-teal of the panel, a lilac highlight.
    'talk_color': '#D9452172',
    'talk_gradient_to': '#D9135360',
    'talk_border_color': '#E4D2FF',
    'talk_text_color': '#FFFFFF',
    'talk_glow_color': '#B3C9A7F0',
    'talk_effect': 'shimmer',
  },
};
