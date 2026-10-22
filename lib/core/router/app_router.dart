import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/scene_player/domain/scene_player_args.dart';
import '../../features/scene_player/presentation/screens/scene_player_screen.dart';
import '../../features/settings/presentation/screens/change_password_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/shop/presentation/screens/shop_screen.dart';
import '../../features/stories/presentation/screens/stories_screen.dart';
import '../../features/story_detail/presentation/screens/story_detail_screen.dart';
import 'app_shell.dart';

/// Bridges Riverpod's [authStateProvider] to go_router's [Listenable]-based
/// `refreshListenable`, so a login/logout change re-evaluates
/// [_redirect] without the widget tree needing to poll or rebuild the
/// router itself.
class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;
}

String? _redirect(Ref ref, GoRouterState state) {
  final authState = ref.read(authStateProvider);
  final isAuthRoute = state.matchedLocation == '/auth';

  switch (authState.status) {
    case AuthStatus.unknown:
      // Bootstrap (reading secure storage) hasn't resolved yet — stay put,
      // AuthScreen is a harmless default to sit on for that brief moment.
      return null;
    case AuthStatus.unauthenticated:
      return isAuthRoute ? null : '/auth';
    case AuthStatus.authenticated:
      // Onboarding is entered explicitly right after a successful
      // registration (see AuthScreen), not gated here on every launch —
      // the backend has no "onboarding completed" flag to check against.
      return isAuthRoute ? '/stories' : null;
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: '/auth',
    refreshListenable: refreshNotifier,
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(
        path: '/story/:id',
        builder: (context, state) => StoryDetailScreen(storyId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/play/:sceneId',
        builder: (context, state) => ScenePlayerScreen(
          sceneId: state.pathParameters['sceneId']!,
          args: state.extra as ScenePlayerArgs?,
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(path: 'change-password', builder: (context, state) => const ChangePasswordScreen()),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/stories', builder: (context, state) => const StoriesScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/shop', builder: (context, state) => const ShopScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen())]),
        ],
      ),
    ],
  );
});
