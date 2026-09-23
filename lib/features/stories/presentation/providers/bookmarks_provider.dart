import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/story_repository.dart';
import 'stories_providers.dart';

/// The set of bookmarked story ids, synced with the backend's
/// `/stories/:id/bookmark` endpoints (`internal/story`'s bookmark module).
/// Starts empty and fills in once the initial `GET /bookmarks` call
/// resolves; [toggle] updates optimistically and rolls back on failure, so
/// the bookmark icon flips instantly without waiting on a round trip.
class BookmarksNotifier extends StateNotifier<Set<String>> {
  BookmarksNotifier(this._repository) : super(const {}) {
    unawaited(_load());
  }

  final StoryRepository _repository;

  Future<void> _load() async {
    try {
      final stories = await _repository.getBookmarks();
      state = stories.map((s) => s.id).toSet();
    } catch (_) {
      // Leave state empty — the bookmark icons just won't show as bookmarked
      // until the next successful load (e.g. a pull-to-refresh).
    }
  }

  Future<void> toggle(String storyId) async {
    final wasBookmarked = state.contains(storyId);
    final previous = state;
    state = wasBookmarked ? ({...state}..remove(storyId)) : ({...state}..add(storyId));

    try {
      if (wasBookmarked) {
        await _repository.removeBookmark(storyId);
      } else {
        await _repository.addBookmark(storyId);
      }
    } catch (_) {
      state = previous;
    }
  }
}

final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, Set<String>>((ref) {
  return BookmarksNotifier(ref.watch(storyRepositoryProvider));
});
