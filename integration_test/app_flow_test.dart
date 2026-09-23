// End-to-end golden path: login -> open a story -> talk to the character in
// free dialog -> send a message -> receive a streamed reply -> close the
// dialog -> make a free choice -> land on the next scene.
//
// Per the architecture doc, this mocks at the repository boundary (auth,
// story, wallet, dialog) rather than spinning up a real backend or a real
// WebSocket server — `dialogRepositoryProvider`/`webSocketClientProvider`
// are overridden directly, so no real socket connection is attempted.
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nocturne/app.dart';
import 'package:nocturne/core/config/app_config.dart';
import 'package:nocturne/core/network/websocket_provider.dart';
import 'package:nocturne/features/auth/data/auth_repository.dart';
import 'package:nocturne/features/auth/domain/models/auth_user.dart';
import 'package:nocturne/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:nocturne/features/dialog/data/dialog_repository.dart';
import 'package:nocturne/features/dialog/domain/models/dialog_message.dart';
import 'package:nocturne/features/dialog/domain/models/dialog_session.dart';
import 'package:nocturne/features/dialog/presentation/providers/dialog_session_provider.dart';
import 'package:nocturne/features/settings/presentation/providers/theme_mode_provider.dart';
import 'package:nocturne/features/stories/data/story_repository.dart';
import 'package:nocturne/features/stories/domain/models/story.dart';
import 'package:nocturne/features/stories/presentation/providers/stories_providers.dart';
import 'package:nocturne/features/wallet/data/wallet_repository.dart';
import 'package:nocturne/features/wallet/presentation/providers/wallet_balance_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockStoryRepository extends Mock implements StoryRepository {}

class _MockWalletRepository extends Mock implements WalletRepository {}

class _MockDialogRepository extends Mock implements DialogRepository {}

const _config = AppConfig(
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
  description: 'A lantern-maker and a scholar exchange letters.',
  genre: 'romance',
  status: 'ongoing',
  createdAt: DateTime(2024, 1, 1),
);

const _scene1 = Scene(
  id: 'sc1',
  storyId: 's1',
  orderIndex: 0,
  characterId: 'char-kate',
  dialogueScript: [
    {'speaker': 'Kate', 'text': 'The lantern still burns, even after all this time.'},
  ],
  freeDialogEnabled: true,
  choices: [Choice(id: 'ch1', text: 'Ask her to stay', isPaid: false, costDiamonds: 0, nextSceneId: 'sc2')],
);

const _scene2 = Scene(
  id: 'sc2',
  storyId: 's1',
  orderIndex: 1,
  dialogueScript: [
    {'speaker': 'Kate', 'text': 'Then I will.'},
  ],
  freeDialogEnabled: false,
  choices: [],
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login, open a story, free-dialog a message, then make a free choice', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await EasyLocalization.ensureInitialized();

    final authRepository = _MockAuthRepository();
    when(() => authRepository.hasStoredSession()).thenAnswer((_) async => false);
    when(
      () => authRepository.login('reader@example.com', 'password123'),
    ).thenAnswer((_) async => const AuthUser(id: 'u1', email: 'reader@example.com', role: 'user'));

    final storyRepository = _MockStoryRepository();
    when(
      () => storyRepository.getStories(
        genre: any(named: 'genre'),
        page: any(named: 'page'),
        pageSize: any(named: 'pageSize'),
      ),
    ).thenAnswer((_) async => StoryPage(items: [_story], total: 1, page: 1, pageSize: 10));
    when(() => storyRepository.getStory('s1')).thenAnswer((_) async => _story);
    when(() => storyRepository.getBookmarks()).thenAnswer((_) async => []);
    when(() => storyRepository.getMyProgress()).thenAnswer((_) async => []);
    when(() => storyRepository.getStoryScenes('s1')).thenAnswer(
      (_) async => const [SceneSummary(id: 'sc1', orderIndex: 0, unlockCostDiamonds: null, isUnlocked: true)],
    );
    when(() => storyRepository.getStoryProgress('s1')).thenAnswer(
      (_) async =>
          PlayerProgress(storyId: 's1', currentSceneId: 'sc1', choicesMade: const [], updatedAt: DateTime(2024, 1, 1)),
    );
    when(() => storyRepository.getScene('sc1')).thenAnswer((_) async => _scene1);
    when(() => storyRepository.getScene('sc2')).thenAnswer((_) async => _scene2);
    when(() => storyRepository.submitChoice('sc1', 'ch1')).thenAnswer(
      (_) async =>
          PlayerProgress(storyId: 's1', currentSceneId: 'sc2', choicesMade: const ['ch1'], updatedAt: DateTime(2024, 1, 2)),
    );

    final walletRepository = _MockWalletRepository();
    when(() => walletRepository.getBalance()).thenAnswer((_) async => 500);

    void Function(String)? onChunk;
    void Function(String)? onComplete;
    final dialogRepository = _MockDialogRepository();
    when(() => dialogRepository.startSession('char-kate', 'sc1')).thenAnswer(
      (_) async => DialogSession(
        id: 'd1',
        characterId: 'char-kate',
        sceneId: 'sc1',
        status: 'active',
        limitType: 'messages',
        limitValue: 20,
        startedAt: DateTime(2024, 1, 1),
      ),
    );
    when(
      () => dialogRepository.subscribeToUpdates(
        any(),
        onChunk: any(named: 'onChunk'),
        onComplete: any(named: 'onComplete'),
        onSessionEnded: any(named: 'onSessionEnded'),
      ),
    ).thenAnswer((invocation) {
      onChunk = invocation.namedArguments[#onChunk] as void Function(String);
      onComplete = invocation.namedArguments[#onComplete] as void Function(String);
    });
    when(() => dialogRepository.sendMessage(any(), any())).thenAnswer(
      (_) async => const DialogMessage(id: 'm1', sender: 'user', text: 'Hi Kate', remainingLimit: 19),
    );
    when(() => dialogRepository.endSession(any())).thenAnswer((_) async {});
    when(() => dialogRepository.unsubscribe()).thenReturn(null);

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ru')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('en'),
        child: ProviderScope(
          overrides: [
            appConfigProvider.overrideWithValue(_config),
            sharedPreferencesProvider.overrideWithValue(prefs),
            authRepositoryProvider.overrideWithValue(authRepository),
            storyRepositoryProvider.overrideWithValue(storyRepository),
            walletRepositoryProvider.overrideWithValue(walletRepository),
            dialogRepositoryProvider.overrideWithValue(dialogRepository),
            // No real socket: dialogRepositoryProvider is overridden above,
            // and this stops the connection-status badge from trying to
            // open one of its own.
            webSocketClientProvider.overrideWithValue(null),
          ],
          child: const LoveCityApp(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // --- 1. Login ---
    expect(find.text('Sign In'), findsWidgets);
    final textFields = find.byType(TextFormField);
    expect(textFields, findsNWidgets(2));
    await tester.enterText(textFields.at(0), 'reader@example.com');
    await tester.enterText(textFields.at(1), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle();

    // --- 2. Stories catalog -> open the story ---
    expect(find.text('Moonlit Vows'), findsWidgets);
    await tester.tap(find.text('Moonlit Vows').first);
    await tester.pumpAndSettle();

    // --- 3. Story detail -> start reading ---
    expect(find.text('Start Reading'), findsOneWidget);
    await tester.tap(find.text('Start Reading'));
    await tester.pumpAndSettle();

    // --- 4. Scene player: open free dialog with Kate ---
    expect(find.text('The lantern still burns, even after all this time.'), findsOneWidget);
    await tester.tap(find.widgetWithIcon(ElevatedButton, LucideIcons.messageCircle));
    await tester.pumpAndSettle();

    // --- 5. Send a message, receive a streamed reply ---
    await tester.enterText(find.byType(TextField), 'Hi Kate');
    await tester.tap(find.byIcon(LucideIcons.send));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('Hi Kate'), findsOneWidget);

    onChunk?.call('I remember');
    onChunk?.call(' you too.');
    await tester.pump();
    onComplete?.call('I remember you too.');
    await tester.pumpAndSettle();
    expect(find.text('I remember you too.'), findsOneWidget);

    // --- 6. Close the dialog overlay, back to the scene ---
    await tester.tap(find.byIcon(LucideIcons.x));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);

    // --- 7. Advance the dialogue to reveal choices, pick the free one ---
    await tester.tap(find.text('The lantern still burns, even after all this time.'));
    await tester.pumpAndSettle();
    expect(find.text('Ask her to stay'), findsOneWidget);
    await tester.tap(find.text('Ask her to stay'));
    await tester.pumpAndSettle();

    // --- 8. Landed on the next scene ---
    expect(find.text('Then I will.'), findsOneWidget);
    verify(() => storyRepository.submitChoice('sc1', 'ch1')).called(1);
  });
}
