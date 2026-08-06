import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:nocturne/features/dialog/presentation/widgets/message_bubble.dart';

import 'golden_helpers.dart';

void main() {
  testGoldens('MessageBubble — streaming character message', (tester) async {
    await pumpGolden(
      tester,
      'message_bubble_streaming',
      overrides: const [],
      child: const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16),
          child: MessageBubble(text: 'The reply is still comin', isUser: false, isStreaming: true),
        ),
      ),
    );
  });
}
