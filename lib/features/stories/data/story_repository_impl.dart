import '../domain/models/story.dart';
import 'story_api.dart';
import 'story_repository.dart';

class StoryRepositoryImpl implements StoryRepository {
  StoryRepositoryImpl({required StoryApi api}) : _api = api;

  final StoryApi _api;

  @override
  Future<List<Story>> getStories() => _api.getStories();

  @override
  Future<List<ProgressSummary>> getMyProgress() => _api.getMyProgress();

  @override
  Future<PlayerProgress> getStoryProgress(String storyId) => _api.getStoryProgress(storyId);

  @override
  Future<List<SceneSummary>> getStoryScenes(String storyId) => _api.getStoryScenes(storyId);

  @override
  Future<Scene> getScene(String sceneId) => _api.getScene(sceneId);

  @override
  Future<PlayerProgress> submitChoice(String sceneId, String choiceId) => _api.submitChoice(sceneId, choiceId);

  @override
  Future<void> unlockScene(String sceneId) => _api.unlockScene(sceneId);
}
