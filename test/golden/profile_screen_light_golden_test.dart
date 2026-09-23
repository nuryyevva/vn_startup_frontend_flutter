import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nocturne/core/config/app_config.dart';
import 'package:nocturne/features/achievements/data/achievements_repository.dart';
import 'package:nocturne/features/achievements/domain/models/achievement.dart';
import 'package:nocturne/features/achievements/presentation/providers/achievements_provider.dart';
import 'package:nocturne/features/profile/data/user_repository.dart';
import 'package:nocturne/features/profile/domain/models/user_profile.dart';
import 'package:nocturne/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:nocturne/features/profile/presentation/screens/profile_screen.dart';
import 'package:nocturne/features/stats/data/stats_repository.dart';
import 'package:nocturne/features/stats/domain/models/user_stats.dart';
import 'package:nocturne/features/stats/presentation/providers/reading_stats_provider.dart';
import 'package:nocturne/features/stories/data/story_repository.dart';
import 'package:nocturne/features/stories/domain/models/story.dart';
import 'package:nocturne/features/stories/presentation/providers/stories_providers.dart';
import 'package:nocturne/features/wallet/data/wallet_repository.dart';
import 'package:nocturne/features/wallet/presentation/providers/wallet_balance_provider.dart';

import 'golden_helpers.dart';

class _MockUserRepository extends Mock implements UserRepository {}

class _MockStoryRepository extends Mock implements StoryRepository {}

class _MockWalletRepository extends Mock implements WalletRepository {}

class _MockStatsRepository extends Mock implements StatsRepository {}

class _MockAchievementsRepository extends Mock implements AchievementsRepository {}

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
  genre: 'romance',
  status: 'ongoing',
  createdAt: DateTime(2024, 1, 1),
);

final _clockworkHeir = Story(
  id: 's2',
  title: 'The Clockwork Heir',
  genre: 'sci_fi',
  status: 'completed',
  createdAt: DateTime(2024, 2, 1),
);

List<Override> _overrides() {
  final userRepository = _MockUserRepository();
  when(() => userRepository.getMe()).thenAnswer(
    (_) async => UserProfile(
      userId: 'u1',
      email: 'wren.castellan@example.com',
      role: 'user',
      createdAt: DateTime(2024, 3, 1),
      updatedAt: DateTime(2024, 3, 1),
      displayName: 'Wren Castellan',
      favoriteGenres: const ['romance', 'fantasy'],
      theme: 'light',
      language: 'en',
    ),
  );

  final storyRepository = _MockStoryRepository();
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
        story: _clockworkHeir,
        currentSceneId: 'sc-last',
        choicesMade: const ['c1', 'c2'],
        updatedAt: DateTime(2024, 6, 2),
        currentSceneOrderIndex: 68,
        totalScenes: 68,
        isFinished: true,
      ),
    ],
  );

  when(() => storyRepository.getBookmarks()).thenAnswer((_) async => []);

  final walletRepository = _MockWalletRepository();
  when(() => walletRepository.getBalance()).thenAnswer((_) async => 1240);

  final statsRepository = _MockStatsRepository();
  when(
    () => statsRepository.getStats(),
  ).thenAnswer((_) async => const UserStats(dayStreak: 5, longestStreak: 12, totalReadingSeconds: 7200, hoursRead: 2));

  final achievementsRepository = _MockAchievementsRepository();
  when(() => achievementsRepository.getAchievements()).thenAnswer(
    (_) async => [
      Achievement(id: 'first_story_finished', title: 'Первая история', description: 'Заверши свою первую историю', unlocked: true, unlockedAt: DateTime(2024, 5, 1)),
      const Achievement(id: 'bookworm', title: 'Книжный червь', description: 'Заверши 10 историй', unlocked: false),
    ],
  );

  return [
    appConfigProvider.overrideWithValue(_testConfig),
    userRepositoryProvider.overrideWithValue(userRepository),
    storyRepositoryProvider.overrideWithValue(storyRepository),
    walletRepositoryProvider.overrideWithValue(walletRepository),
    statsRepositoryProvider.overrideWithValue(statsRepository),
    achievementsRepositoryProvider.overrideWithValue(achievementsRepository),
  ];
}

void main() {
  testGoldens('ProfileScreen — light', (tester) async {
    await pumpGolden(
      tester,
      'profile_screen_light',
      brightness: Brightness.light,
      surfaceSize: const Size(400, 1100),
      overrides: _overrides(),
      child: const ProfileScreen(),
    );
  });
}
