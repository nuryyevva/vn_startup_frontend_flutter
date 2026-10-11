import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/websocket_provider.dart';
import '../achievements/presentation/providers/achievements_provider.dart';
import '../auth/presentation/providers/auth_state_provider.dart';
import '../profile/presentation/providers/user_profile_provider.dart';
import '../stats/presentation/providers/reading_stats_provider.dart';
import '../stories/presentation/providers/stories_providers.dart';
import '../wallet/presentation/providers/wallet_balance_provider.dart';
import 'data/bundled_content.dart';
import 'data/bundled_story_repository.dart';
import 'data/local_player_repositories.dart';
import 'data/local_store.dart';
import 'data/local_wallet.dart';

/// Provider overrides that make the app run with no server at all
/// (`AppConfig.offline`): stories come from the app bundle and the player's
/// state lives on the device.
///
/// The swap happens at the repository layer and nowhere else — screens,
/// notifiers and the scene player are the same code in both modes, they
/// just get these repositories instead of the HTTP-backed ones. Nothing
/// opens a network connection: no API client is ever read, no WebSocket is
/// created, and fonts come from the bundle too.
///
/// What isn't available offline: free dialogue with AI characters (it runs
/// on the server), and anything tied to an account — the player's state is
/// local to this device.
Future<List<Override>> offlineModeOverrides(SharedPreferences prefs) async {
  // Fonts are bundled (assets/google_fonts); never reach for the network.
  GoogleFonts.config.allowRuntimeFetching = false;

  final content = await BundledContent.load();
  final store = LocalStore(prefs);
  final wallet = LocalWallet(store);
  final stories = BundledStoryRepository(content: content, store: store, wallet: wallet);
  final stats = LocalStatsRepository(store);

  return [
    authRepositoryProvider.overrideWithValue(const LocalAuthRepository()),
    storyRepositoryProvider.overrideWithValue(stories),
    walletRepositoryProvider.overrideWithValue(wallet),
    userRepositoryProvider.overrideWithValue(LocalUserRepository(store)),
    statsRepositoryProvider.overrideWithValue(stats),
    achievementsRepositoryProvider.overrideWithValue(
      LocalAchievementsRepository(store: store, stories: stories, wallet: wallet, stats: stats),
    ),
    // No socket: it only carries AI dialogue, and with it null the dialog
    // repository is never built either.
    webSocketClientProvider.overrideWithValue(null),
  ];
}
