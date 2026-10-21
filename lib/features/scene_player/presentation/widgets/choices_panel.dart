import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../stories/domain/models/story.dart';
import '../theme/scene_player_skin.dart';
import 'skin_panel.dart';
import 'talk_choice_button.dart';

/// Replaces the dialogue box once its script is exhausted (project spec
/// §8.4 layer 4). Paid choices show their diamond cost and disable
/// themselves when the player can't afford them — never silently allow a
/// choice the backend would reject with `insufficient_funds`.
class ChoicesPanel extends StatelessWidget {
  const ChoicesPanel({
    super.key,
    required this.choices,
    required this.walletBalance,
    required this.onSelect,
    this.pendingChoiceId,
    this.onTalk,
    this.talkLabel,
  });

  final List<Choice> choices;
  final int? walletBalance;
  final ValueChanged<Choice> onSelect;

  /// Free conversation offered as one more answer among the scripted ones (only in scenes where the author
  /// enabled it): null hides the option. [talkLabel] is its text, e.g. "Talk to Noah".
  final VoidCallback? onTalk;
  final String? talkLabel;

  /// The choice just made, while the next scene loads: it keeps its look
  /// and shows a spinner, the others are disabled.
  final String? pendingChoiceId;

  @override
  Widget build(BuildContext context) {
    final skin = ScenePlayerSkin.of(context);
    return SkinPanel(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final choice in choices) ...[
            _buildChoice(skin, choice),
            if (choice != choices.last) const SizedBox(height: 10),
          ],
          if (onTalk != null) ...[
            // A little more air: it's a different kind of answer.
            if (choices.isNotEmpty) const SizedBox(height: 14),
            TalkChoiceButton(label: talkLabel ?? '', onPressed: pendingChoiceId == null ? onTalk : null),
          ],
        ],
      ),
    );
  }

  Widget _buildChoice(ScenePlayerSkin skin, Choice choice) {
    final affordable = !choice.isPaid || walletBalance == null || walletBalance! >= choice.costDiamonds;
    final isPending = choice.id == pendingChoiceId;
    final VoidCallback? onPressed = pendingChoiceId != null
        // Enabled-looking but inert, so the chosen answer doesn't dim.
        ? (isPending ? () {} : null)
        : (affordable ? () => onSelect(choice) : null);
    return SkinButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Text(choice.text, textAlign: TextAlign.center)),
          if (isPending) ...[
            const SizedBox(width: 10),
            SizedBox.square(dimension: 14, child: CircularProgressIndicator(strokeWidth: 2, color: skin.accentColor)),
          ],
          if (choice.isPaid) ...[
            const SizedBox(width: 8),
            Icon(LucideIcons.gem, size: 14, color: affordable ? skin.accentColor : null),
            const SizedBox(width: 4),
            Text('${choice.costDiamonds}'),
          ],
        ],
      ),
    );
  }
}

/// A full-width button in the story's skin — the choice buttons, and any
/// other action offered on a [SkinPanel]. With no choice tokens in the
/// skin this is exactly the app's own outlined button.
class SkinButton extends StatelessWidget {
  const SkinButton({super.key, required this.onPressed, required this.child});

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final skin = ScenePlayerSkin.of(context);
    final radius = skin.choiceRadius;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: skin.choiceColor,
          foregroundColor: skin.choiceTextColor,
          // The app's own disabled colour assumes the app's surface; on a
          // skinned button it can vanish (pale grey on parchment).
          disabledForegroundColor: skin.choiceTextColor?.withValues(alpha: 0.5),
          side: skin.choiceBorderColor == null ? null : BorderSide(color: skin.choiceBorderColor!),
          // A stadium rather than a huge radius, so multi-line labels in a
          // "pill" skin don't get their corners eaten.
          shape: radius == null
              ? null
              : radius >= 100
              ? const StadiumBorder()
              : RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
          textStyle: skin.bodyStyle(Theme.of(context).textTheme.labelLarge),
        ),
        child: child,
      ),
    );
  }
}
