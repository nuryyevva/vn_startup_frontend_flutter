import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nocturne/features/dialog/presentation/widgets/message_bubble.dart';

import 'golden_helpers.dart';

void main() {
  testGoldens('MessageBubble — error state', (tester) async {
    await pumpGolden(
      tester,
      'message_bubble_error',
      overrides: const [],
      child: const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: MessageBubble(text: "Couldn't send this message", isUser: true, isError: true),
        ),
      ),
    );
  });
}
