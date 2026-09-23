import '../domain/models/story.dart';

abstract class StoryRepository {
  Future<StoryPage> getStories({String? genre, int page = 1, int? pageSize});
  Future<Story> getStory(String storyId);
  Future<List<ProgressSummary>> getMyProgress();
  Future<PlayerProgress> getStoryProgress(String storyId);
  Future<List<SceneSummary>> getStoryScenes(String storyId);
  Future<Scene> getScene(String sceneId);
  Future<PlayerProgress> submitChoice(String sceneId, String choiceId);
  Future<void> unlockScene(String sceneId);
  Future<List<Story>> getBookmarks();
  Future<void> addBookmark(String storyId);
  Future<void> removeBookmark(String storyId);
}
