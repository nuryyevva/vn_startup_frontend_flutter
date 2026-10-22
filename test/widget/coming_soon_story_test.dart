import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nocturne/core/theme/app_theme.dart';
import 'package:nocturne/features/stories/domain/models/story.dart';
import 'package:nocturne/features/stories/presentation/open_story.dart';
import 'package:nocturne/features/stories/presentation/widgets/story_card.dart';

Story _story({required bool comingSoon}) => Story(
  id: comingSoon ? 'alice' : 'blackwood',
  title: comingSoon ? 'Alice' : 'Blackwood',
  genre: 'mystery',
  status: 'ongoing',
  createdAt: DateTime(2026),
  comingSoon: comingSoon,
);

Future<void> _pump(WidgetTester tester, Story story) async {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: SizedBox(
            width: 200,
            child: StoryCard(story: story, onTap: () => openStory(context, story)),
          ),
        ),
      ),
      GoRoute(path: '/story/:id', builder: (context, state) => Text('story page ${state.pathParameters['id']}')),
    ],
  );
  await tester.pumpWidget(MaterialApp.router(theme: AppTheme.dark(), routerConfig: router));
  await tester.pumpAndSettle();
}

void main() {
  // No EasyLocalization here: .tr() returns the key itself.
  testWidgets('a coming-soon story is marked and only says so when tapped', (tester) async {
    await _pump(tester, _story(comingSoon: true));

    expect(find.text('stories.comingSoon'), findsOneWidget);

    await tester.tap(find.text('Alice'));
    await tester.pumpAndSettle();

    expect(find.text('stories.comingSoonToast'), findsOneWidget);
    expect(find.textContaining('story page'), findsNothing);
  });

  testWidgets('any other story opens as usual', (tester) async {
    await _pump(tester, _story(comingSoon: false));

    expect(find.text('stories.comingSoon'), findsNothing);

    await tester.tap(find.text('Blackwood'));
    await tester.pumpAndSettle();

    expect(find.text('story page blackwood'), findsOneWidget);
  });
}
