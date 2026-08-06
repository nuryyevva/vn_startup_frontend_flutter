import '../domain/models/story.dart';

abstract class StoryRepository {
  Future<List<Story>> getStories();
  Future<List<ProgressSummary>> getMyProgress();
  Future<PlayerProgress> getStoryProgress(String storyId);
  Future<List<SceneSummary>> getStoryScenes(String storyId);
  Future<Scene> getScene(String sceneId);
  Future<PlayerProgress> submitChoice(String sceneId, String choiceId);
  Future<void> unlockScene(String sceneId);
}
