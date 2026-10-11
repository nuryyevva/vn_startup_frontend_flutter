import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../domain/dialogue_line.dart';
import 'dialogue_box.dart';

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
                          DialogueText(
                            text: line.text,
                            style: line.isThought
                                ? DialogueStyle.thought
                                : line.isNarration
                                ? DialogueStyle.narration
                                : DialogueStyle.speech,
                            baseStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
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
