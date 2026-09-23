import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nocturne/core/config/app_config.dart';
import 'package:nocturne/features/settings/presentation/providers/theme_mode_provider.dart';
import 'package:nocturne/features/stories/data/story_repository.dart';
import 'package:nocturne/features/stories/domain/models/story.dart';
import 'package:nocturne/features/stories/presentation/providers/stories_providers.dart';
import 'package:nocturne/features/story_detail/presentation/screens/story_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'golden_helpers.dart';

class _MockStoryRepository extends Mock implements StoryRepository {}

const _testConfig = AppConfig(
  appName: 'Nocturne',
  environment: AppEnvironment.dev,
  apiBaseUrl: 'http://localhost:8080',
  wsBaseUrl: 'ws://localhost:8080',
  apiTimeout: Duration(seconds: 10),
  tokenRefreshMargin: Duration(seconds: 30),
  storiesPageSize: 10,
  defaultLocale: 'en',
  supportedLocales: ['en', 'ru'],
  defaultThemeMode: ThemeMode.dark,
  enableDevWalletGrant: true,
  termsPrivacyUrl: 'https://example.com',
);

final _story = Story(
  id: 's1',
  title: 'Moonlit Vows',
  description:
      'A reclusive lantern-maker and a traveling scholar exchange letters across a single moonlit season — until the season runs out.',
  genre: 'romance',
  status: 'ongoing',
  createdAt: DateTime(2024, 1, 1),
);

const _scenes = [
  SceneSummary(id: 'sc1', orderIndex: 0, unlockCostDiamonds: null, isUnlocked: true),
  SceneSummary(id: 'sc2', orderIndex: 1, unlockCostDiamonds: null, isUnlocked: true),
  SceneSummary(id: 'sc3', orderIndex: 2, unlockCostDiamonds: null, isUnlocked: true),
  SceneSummary(id: 'sc4', orderIndex: 3, unlockCostDiamonds: 25, isUnlocked: false),
];

List<Override> _overrides() {
  final storyRepository = _MockStoryRepository();
  when(() => storyRepository.getStory('s1')).thenAnswer((_) async => _story);
  when(() => storyRepository.getBookmarks()).thenAnswer((_) async => []);
  when(() => storyRepository.getStoryScenes('s1')).thenAnswer((_) async => _scenes);
  when(() => storyRepository.getStoryProgress('s1')).thenAnswer(
    (_) async => PlayerProgress(
      storyId: 's1',
      currentSceneId: 'sc3',
      choicesMade: const ['c1', 'c2'],
      updatedAt: DateTime(2024, 6, 1),
    ),
  );

  return [
    appConfigProvider.overrideWithValue(_testConfig),
    storyRepositoryProvider.overrideWithValue(storyRepository),
  ];
}

void main() {
  testGoldens('StoryDetailScreen — light', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await pumpGolden(
      tester,
      'story_detail_screen_light',
      brightness: Brightness.light,
      surfaceSize: const Size(400, 900),
      overrides: [..._overrides(), sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const StoryDetailScreen(storyId: 's1'),
    );
  });
}
