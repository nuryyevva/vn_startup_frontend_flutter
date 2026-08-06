import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../stories/domain/models/story.dart';

/// Replaces the dialogue box once its script is exhausted (project spec
/// §8.4 layer 4). Paid choices show their diamond cost and disable
/// themselves when the player can't afford them — never silently allow a
/// choice the backend would reject with `insufficient_funds`.
class ChoicesPanel extends StatelessWidget {
  const ChoicesPanel({super.key, required this.choices, required this.walletBalance, required this.onSelect});

  final List<Choice> choices;
  final int? walletBalance;
  final ValueChanged<Choice> onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.92),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final choice in choices) ...[
            _ChoiceButton(
              choice: choice,
              affordable: !choice.isPaid || walletBalance == null || walletBalance! >= choice.costDiamonds,
              onTap: () => onSelect(choice),
            ),
            if (choice != choices.last) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({required this.choice, required this.affordable, required this.onTap});

  final Choice choice;
  final bool affordable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: affordable ? onTap : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: Text(choice.text, textAlign: TextAlign.center)),
            if (choice.isPaid) ...[
              const SizedBox(width: 8),
              Icon(LucideIcons.gem, size: 14, color: affordable ? colors.accent : colors.textMuted),
              const SizedBox(width: 4),
              Text('${choice.costDiamonds}'),
            ],
          ],
        ),
      ),
    );
  }
}
