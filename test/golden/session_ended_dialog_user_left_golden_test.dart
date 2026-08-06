import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nocturne/features/dialog/domain/models/session_end_reason.dart';
import 'package:nocturne/features/dialog/presentation/widgets/session_ended_dialog.dart';

import 'golden_helpers.dart';

void main() {
  testGoldens('SessionEndedDialog — userLeft', (tester) async {
    await pumpGolden(
      tester,
      'session_ended_dialog_userLeft',
      overrides: const [],
      surfaceSize: const Size(400, 400),
      child: Scaffold(
        body: Center(
          child: SessionEndedDialog(reason: SessionEndReason.userLeft, characterName: 'Kate', onBackToStory: () {}),
        ),
      ),
    );
  });
}
