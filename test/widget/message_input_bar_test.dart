import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:nocturne/core/theme/app_theme.dart';
import 'package:nocturne/features/dialog/presentation/widgets/message_input_bar.dart';

Widget _host(Widget child) => MaterialApp(theme: AppTheme.dark(), home: Scaffold(body: child));

void main() {
  testWidgets('the send button shows the price of a message', (tester) async {
    final sent = <String>[];
    await tester.pumpWidget(_host(MessageInputBar(onSend: sent.add, enabled: true, messageCost: 10)));

    expect(find.text('10'), findsOneWidget);
    expect(find.byIcon(LucideIcons.gem), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Привет');
    await tester.tap(find.byIcon(LucideIcons.send));
    expect(sent, ['Привет']);
  });

  testWidgets('no price from the backend: just the send icon', (tester) async {
    await tester.pumpWidget(_host(MessageInputBar(onSend: (_) {}, enabled: true)));

    expect(find.byIcon(LucideIcons.send), findsOneWidget);
    expect(find.byIcon(LucideIcons.gem), findsNothing);
  });
}
