import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../data/story_api.dart';
import '../../data/story_repository.dart';
import '../../data/story_repository_impl.dart';
import '../../domain/models/story.dart';

final storyApiProvider = Provider<StoryApi>((ref) => StoryApi(ref.watch(dioProvider)));

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepositoryImpl(api: ref.watch(storyApiProvider));
});

/// The full published catalog, fetched once. The backend has no
/// server-side genre filter or pagination on `GET /stories` (see README
/// "known limitations"), so filtering/paging both happen client-side over
/// this cached list — see [filteredStoriesProvider] and
/// [storiesVisibleCountProvider].
final allStoriesProvider = FutureProvider<List<Story>>((ref) {
  return ref.watch(storyRepositoryProvider).getStories();
});

/// Every story the signed-in user has already started, most recently
/// updated first — feeds both the stories screen's "Continue Reading" rail
/// and the profile screen's "My Library" / finished-count stat.
final myProgressProvider = FutureProvider<List<ProgressSummary>>((ref) {
  return ref.watch(storyRepositoryProvider).getMyProgress();
});

/// A single story's progress, creating it (pointed at the first scene) if
/// the player has never opened this story before — only ever called for a
/// story the player is actively entering (story_detail, scene_player),
/// never in a loop over the catalog (see [myProgressProvider] for that).
final storyProgressProvider = FutureProvider.family<PlayerProgress, String>((ref, storyId) {
  return ref.watch(storyRepositoryProvider).getStoryProgress(storyId);
});

final storyScenesProvider = FutureProvider.family<List<SceneSummary>, String>((ref, storyId) {
  return ref.watch(storyRepositoryProvider).getStoryScenes(storyId);
});

/// `null` means the "All" chip — no filter applied.
final selectedGenreProvider = StateProvider<String?>((ref) => null);

final filteredStoriesProvider = Provider<AsyncValue<List<Story>>>((ref) {
  final storiesAsync = ref.watch(allStoriesProvider);
  final genre = ref.watch(selectedGenreProvider);
  return storiesAsync.whenData((stories) {
    if (genre == null) return stories;
    return stories.where((story) => story.genre == genre).toList(growable: false);
  });
});

/// How many of [filteredStoriesProvider]'s results are currently visible —
/// the client-side stand-in for real pagination (see [allStoriesProvider]'s
/// doc comment). Grows by `AppConfig.storiesPageSize` on [loadMore]; the
/// stories screen resets it to one page whenever the genre filter changes.
class StoriesVisibleCountNotifier extends StateNotifier<int> {
  StoriesVisibleCountNotifier(this._pageSize) : super(_pageSize);

  final int _pageSize;

  void loadMore() => state += _pageSize;

  void reset() => state = _pageSize;
}

final storiesVisibleCountProvider = StateNotifierProvider<StoriesVisibleCountNotifier, int>((ref) {
  return StoriesVisibleCountNotifier(ref.watch(appConfigProvider).storiesPageSize);
});
