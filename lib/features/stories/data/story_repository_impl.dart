import '../domain/models/story.dart';
import 'story_api.dart';
import 'story_repository.dart';

class StoryRepositoryImpl implements StoryRepository {
  StoryRepositoryImpl({required StoryApi api}) : _api = api;

  final StoryApi _api;

  @override
  Future<StoryPage> getStories({String? genre, int page = 1, int? pageSize}) =>
      _api.getStories(genre: genre, page: page, pageSize: pageSize);

  @override
  Future<Story> getStory(String storyId) => _api.getStory(storyId);

  @override
  Future<List<ProgressSummary>> getMyProgress() => _api.getMyProgress();

  @override
  Future<PlayerProgress> getStoryProgress(String storyId) => _api.getStoryProgress(storyId);

  @override
  Future<PlayerProgress> restartStory(String storyId, {String? fromSceneId}) =>
      _api.restartStory(storyId, fromSceneId: fromSceneId);

  @override
  Future<List<SceneSummary>> getStoryScenes(String storyId) => _api.getStoryScenes(storyId);

  @override
  Future<Scene> getScene(String sceneId) => _api.getScene(sceneId);

  @override
  Future<PlayerProgress> submitChoice(String sceneId, String choiceId) => _api.submitChoice(sceneId, choiceId);

  @override
  Future<void> unlockScene(String sceneId) => _api.unlockScene(sceneId);

  @override
  Future<List<Story>> getBookmarks() => _api.getBookmarks();

  @override
  Future<void> addBookmark(String storyId) => _api.addBookmark(storyId);

  @override
  Future<void> removeBookmark(String storyId) => _api.removeBookmark(storyId);
}
