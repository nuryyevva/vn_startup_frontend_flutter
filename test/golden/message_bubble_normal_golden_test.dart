import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nocturne/features/dialog/presentation/widgets/message_bubble.dart';

import 'golden_helpers.dart';

// Golden tests deliberately live one-per-file: repeated `pumpGolden` calls
// within a single test file/process reliably corrupt every capture from
// the 3rd call onward (confirmed to reproduce with both MessageBubble and
// SessionEndedDialog, independent of widget content) — a test-binding
// resource leak somewhere in the golden_toolkit / flutter_test stack that
// one-test-per-file sidesteps entirely.
void main() {
  testGoldens('MessageBubble — normal user and character messages', (tester) async {
    await pumpGolden(
      tester,
      'message_bubble_normal',
      overrides: const [],
      child: const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              MessageBubble(text: 'Hi there! How are you?', isUser: true),
              MessageBubble(text: 'Doing well, thanks for asking!', isUser: false),
            ],
          ),
        ),
      ),
    );
  });
}
