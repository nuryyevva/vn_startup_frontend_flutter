import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nocturne/core/config/app_config.dart';
import 'package:nocturne/features/settings/presentation/providers/theme_mode_provider.dart';
import 'package:nocturne/features/stories/data/story_repository.dart';
import 'package:nocturne/features/stories/domain/models/story.dart';
import 'package:nocturne/features/stories/presentation/providers/stories_providers.dart';
import 'package:nocturne/features/stories/presentation/screens/stories_screen.dart';
import 'package:nocturne/features/wallet/data/wallet_repository.dart';
import 'package:nocturne/features/wallet/presentation/providers/wallet_balance_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'golden_helpers.dart';

class _MockStoryRepository extends Mock implements StoryRepository {}

class _MockWalletRepository extends Mock implements WalletRepository {}

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

final _moonlitVows = Story(
  id: 's1',
  title: 'Moonlit Vows',
  description: 'A reclusive lantern-maker and a traveling scholar exchange letters.',
  genre: 'romance',
  status: 'ongoing',
  createdAt: DateTime(2024, 1, 1),
);

final _nightshadeSociety = Story(
  id: 's2',
  title: 'Nightshade Society',
  description: 'A secret order hunts monsters in a gaslit city.',
  genre: 'fantasy',
  status: 'ongoing',
  createdAt: DateTime(2024, 2, 1),
);

final _clockworkHeir = Story(
  id: 's3',
  title: 'The Clockwork Heir',
  description: 'An engineer inherits a war she never asked for.',
  genre: 'sci_fi',
  status: 'completed',
  createdAt: DateTime(2024, 3, 1),
);

List<Override> _overrides() {
  final storyRepository = _MockStoryRepository();
  when(
    () => storyRepository.getStories(
      genre: any(named: 'genre'),
      page: any(named: 'page'),
      pageSize: any(named: 'pageSize'),
    ),
  ).thenAnswer(
    (_) async => StoryPage(items: [_moonlitVows, _nightshadeSociety, _clockworkHeir], total: 3, page: 1, pageSize: 10),
  );
  when(() => storyRepository.getBookmarks()).thenAnswer((_) async => []);
  when(() => storyRepository.getMyProgress()).thenAnswer(
    (_) async => [
      ProgressSummary(
        story: _moonlitVows,
        currentSceneId: 'sc2',
        choicesMade: const ['c1'],
        updatedAt: DateTime(2024, 6, 1),
        currentSceneOrderIndex: 28,
        totalScenes: 42,
        isFinished: false,
      ),
      ProgressSummary(
        story: _nightshadeSociety,
        currentSceneId: 'sc1',
        choicesMade: const [],
        updatedAt: DateTime(2024, 6, 2),
        currentSceneOrderIndex: 23,
        totalScenes: 68,
        isFinished: false,
      ),
    ],
  );

  final walletRepository = _MockWalletRepository();
  when(() => walletRepository.getBalance()).thenAnswer((_) async => 1240);

  return [
    appConfigProvider.overrideWithValue(_testConfig),
    storyRepositoryProvider.overrideWithValue(storyRepository),
    walletRepositoryProvider.overrideWithValue(walletRepository),
  ];
}

void main() {
  testGoldens('StoriesScreen — light', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await pumpGolden(
      tester,
      'stories_screen_light',
      brightness: Brightness.light,
      surfaceSize: const Size(400, 900),
      overrides: [..._overrides(), sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const StoriesScreen(),
    );
  });
}
