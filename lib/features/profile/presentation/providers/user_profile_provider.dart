import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_client.dart';
import '../../data/user_api.dart';
import '../../data/user_repository.dart';
import '../../data/user_repository_impl.dart';
import '../../domain/models/user_profile.dart';

part 'user_profile_provider.g.dart';

final userApiProvider = Provider<UserApi>((ref) => UserApi(ref.watch(dioProvider)));

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(api: ref.watch(userApiProvider));
});

/// The current user's profile — fetched once on first read, invalidated
/// (re-fetched) after every successful [update] so every screen showing
/// profile data (profile, settings, onboarding) stays in sync.
@riverpod
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Future<UserProfile> build() {
    return ref.watch(userRepositoryProvider).getMe();
  }

  /// Named `updateProfile`, not `update` — `AsyncNotifier` already declares
  /// a built-in `update` (cache-mutation helper) that this would otherwise
  /// collide with.
  Future<void> updateProfile(UpdateProfileRequest request) async {
    final repository = ref.read(userRepositoryProvider);
    // copyWithPrevious keeps `valueOrNull` returning the last-known profile
    // while this PATCH is in flight, instead of going briefly null — screens
    // that read individual fields straight off the profile (e.g. the
    // notification toggles in SettingsScreen) would otherwise flash back to
    // a fallback default for the round-trip's duration.
    state = const AsyncValue<UserProfile>.loading().copyWithPrevious(state);
    state = await AsyncValue.guard(() => repository.updateMe(request));
  }
}
