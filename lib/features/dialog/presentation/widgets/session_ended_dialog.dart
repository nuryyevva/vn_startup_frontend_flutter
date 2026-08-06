import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../domain/models/session_end_reason.dart';

/// One of 4 localized states by `reason` (project spec §8.5 / architecture
/// doc). `characterName` is only used by [SessionEndReason.storyEvent]'s
/// body text (e.g. "Kate had to go — the story is calling").
class SessionEndedDialog extends StatelessWidget {
  const SessionEndedDialog({super.key, required this.reason, required this.characterName, required this.onBackToStory});

  final SessionEndReason reason;
  final String characterName;
  final VoidCallback onBackToStory;

  @override
  Widget build(BuildContext context) {
    final (title, body) = switch (reason) {
      SessionEndReason.timeLimit => ('dialog.sessionEnded.timeLimitTitle'.tr(), 'dialog.sessionEnded.timeLimitBody'.tr()),
      SessionEndReason.messageLimit => (
        'dialog.sessionEnded.messageLimitTitle'.tr(),
        'dialog.sessionEnded.messageLimitBody'.tr(),
      ),
      SessionEndReason.storyEvent => (
        'dialog.sessionEnded.storyEventTitle'.tr(),
        'dialog.sessionEnded.storyEventBody'.tr(args: [characterName]),
      ),
      SessionEndReason.userLeft => ('dialog.sessionEnded.userLeftTitle'.tr(), 'dialog.sessionEnded.userLeftBody'.tr()),
    };

    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [ElevatedButton(onPressed: onBackToStory, child: Text('dialog.sessionEnded.backToStory'.tr()))],
    );
  }
}
