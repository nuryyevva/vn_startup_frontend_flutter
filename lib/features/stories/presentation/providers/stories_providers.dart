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

/// A single story's metadata, used by the story-detail screen — `GET
/// /stories` is now paginated (see [StoriesListNotifier]), so it's no
/// longer a reliable place to look up one story by id.
final storyByIdProvider = FutureProvider.family<Story, String>((ref, storyId) {
  return ref.watch(storyRepositoryProvider).getStory(storyId);
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

/// One page's worth of the published catalog, accumulated as the user
/// scrolls. The backend paginates and filters by genre server-side (`GET
/// /stories?genre=&page=`), so this notifier's job is just to track which
/// page it's on and append results — no client-side filtering/slicing.
class StoriesPageState {
  const StoriesPageState({this.items = const [], this.total = 0, this.loadedPage = 0, this.isLoadingMore = false});

  final List<Story> items;
  final int total;

  /// The last page number successfully appended; 0 means nothing loaded yet.
  final int loadedPage;
  final bool isLoadingMore;

  bool get hasMore => items.length < total;

  StoriesPageState copyWith({List<Story>? items, int? total, int? loadedPage, bool? isLoadingMore}) {
    return StoriesPageState(
      items: items ?? this.items,
      total: total ?? this.total,
      loadedPage: loadedPage ?? this.loadedPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class StoriesListNotifier extends StateNotifier<AsyncValue<StoriesPageState>> {
  StoriesListNotifier(this._repository, this._pageSize) : super(const AsyncValue.loading()) {
    _load(reset: true);
  }

  final StoryRepository _repository;
  final int _pageSize;
  String? _genre;

  Future<void> setGenre(String? genre) {
    if (_genre == genre) return Future.value();
    _genre = genre;
    return refresh();
  }

  Future<void> refresh() {
    state = const AsyncValue.loading();
    return _load(reset: true);
  }

  Future<void> loadMore() {
    final current = state.valueOrNull;
    if (current == null || current.isLoadingMore || !current.hasMore) return Future.value();
    state = AsyncValue.data(current.copyWith(isLoadingMore: true));
    return _load(reset: false);
  }

  Future<void> _load({required bool reset}) async {
    final nextPage = reset ? 1 : (state.valueOrNull?.loadedPage ?? 0) + 1;
    try {
      final page = await _repository.getStories(genre: _genre, page: nextPage, pageSize: _pageSize);
      final previousItems = reset ? const <Story>[] : (state.valueOrNull?.items ?? const <Story>[]);
      state = AsyncValue.data(
        StoriesPageState(items: [...previousItems, ...page.items], total: page.total, loadedPage: page.page),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final storiesListProvider = StateNotifierProvider<StoriesListNotifier, AsyncValue<StoriesPageState>>((ref) {
  final notifier = StoriesListNotifier(ref.watch(storyRepositoryProvider), ref.watch(appConfigProvider).storiesPageSize);
  ref.listen(selectedGenreProvider, (_, genre) => notifier.setGenre(genre));
  return notifier;
});
