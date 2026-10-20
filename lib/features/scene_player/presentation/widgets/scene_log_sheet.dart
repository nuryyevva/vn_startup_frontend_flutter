import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/dialogue_line.dart';

/// All dialogue lines from the scene's script up to and including the
/// current one — purely derived from data already fetched, no separate
/// request needed.
void showSceneLogSheet(BuildContext context, {required List<DialogueLine> lines}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('scenePlayer.logTitle'.tr(), style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: lines.length,
                    separatorBuilder: (context, index) => const Divider(height: 20),
                    itemBuilder: (context, index) {
                      final line = lines[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (line.speakerName.isNotEmpty)
                            Text(line.speakerName, style: Theme.of(context).textTheme.titleMedium),
                          _LogText(line: line),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// A log entry's text in the sheet's own colours: the sheet sits on the app's dark surface, so the story skin's
/// text colour (dark on a parchment skin) would be unreadable here.
class _LogText extends StatelessWidget {
  const _LogText({required this.line});

  final DialogueLine line;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = Theme.of(context).textTheme.bodyMedium;
    if (line.isNarration) {
      return Text(line.text, style: base?.copyWith(fontStyle: FontStyle.italic, color: colors.textSecondary));
    }
    if (line.isThought) {
      return Container(
        padding: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: colors.accent.withValues(alpha: 0.7), width: 2)),
        ),
        child: Text(line.text, style: base?.copyWith(fontStyle: FontStyle.italic, color: colors.textPrimary)),
      );
    }
    return Text(line.text, style: base?.copyWith(color: colors.textPrimary));
  }
}