import 'package:flutter/material.dart';

import '../theme/scene_player_skin.dart';
import 'skin_panel.dart';

/// How a line reads: someone speaking, scene narration, or the heroine's
/// inner voice (see `DialogueLine`).
enum DialogueStyle { speech, narration, thought }

/// Speaker name + line text on the story's [SkinPanel]; tap anywhere on
/// the scene to advance (project spec §8.4 layer 3). Text appears whole —
/// no typewriter effect; that's reserved for the free-dialogue WS stream
/// (§8.5), not this static, pre-authored script.
class DialogueBox extends StatelessWidget {
  const DialogueBox({super.key, required this.speaker, required this.text, this.style = DialogueStyle.speech});

  final String speaker;
  final String text;
  final DialogueStyle style;

  @override
  Widget build(BuildContext context) {
    final skin = ScenePlayerSkin.of(context);
    final textTheme = Theme.of(context).textTheme;
    return SkinPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (speaker.isNotEmpty && style == DialogueStyle.speech)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                skin.speakerCaps ? speaker.toUpperCase() : speaker,
                style: skin.speakerStyle(textTheme.titleMedium),
              ),
            ),
          DialogueText(text: text, style: style),
        ],
      ),
    );
  }
}

/// The line text alone, styled per [DialogueStyle] and the story's skin —
/// shared with the scene log so a thought reads as a thought there too.
class DialogueText extends StatelessWidget {
  const DialogueText({super.key, required this.text, required this.style, this.baseStyle});

  final String text;
  final DialogueStyle style;

  /// Defaults to `bodyLarge`.
  final TextStyle? baseStyle;

  @override
  Widget build(BuildContext context) {
    final skin = ScenePlayerSkin.of(context);
    final base = skin.bodyStyle(baseStyle ?? Theme.of(context).textTheme.bodyLarge);
    return switch (style) {
      DialogueStyle.speech => Text(text, style: base?.copyWith(color: skin.textColor)),
      DialogueStyle.narration => Text(
        text,
        style: base?.copyWith(fontStyle: FontStyle.italic, color: skin.narrationColor),
      ),
      // Inner voice: italic like narration, but in the speech colour and
      // set off by an accent rule so the two never blur together.
      DialogueStyle.thought => Container(
        padding: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: skin.accentColor.withValues(alpha: 0.7), width: 2)),
        ),
        child: Text(
          text,
          style: base?.copyWith(fontStyle: FontStyle.italic, color: skin.textColor),
        ),
      ),
    };
  }
}
