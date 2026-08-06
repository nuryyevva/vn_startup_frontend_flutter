import 'package:dio/dio.dart';

import '../domain/models/story.dart';

/// Hand-written Dio wrapper for `/stories/*`, `/scenes/*`, and `/progress`
/// — see `AuthApi`'s doc comment for why this isn't retrofit-generated.
class StoryApi {
  StoryApi(this._dio);

  final Dio _dio;

  Future<List<Story>> getStories() async {
    final response = await _dio.get<List<dynamic>>('/stories');
    return response.data!.map((e) => Story.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// All stories the caller has already started, most recently updated
  /// first. Never creates progress rows (unlike [getStoryProgress]).
  Future<List<ProgressSummary>> getMyProgress() async {
    final response = await _dio.get<List<dynamic>>('/progress');
    return response.data!.map((e) => ProgressSummary.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Creates a fresh progress row (pointed at the story's first scene) if
  /// the caller has none yet — that side effect is exactly why this is
  /// only called for a story the player is actively opening, never in a
  /// loop over the whole catalog.
  Future<PlayerProgress> getStoryProgress(String storyId) async {
    final response = await _dio.get<Map<String, dynamic>>('/stories/$storyId/progress');
    return PlayerProgress.fromJson(response.data!);
  }

  Future<List<SceneSummary>> getStoryScenes(String storyId) async {
    final response = await _dio.get<List<dynamic>>('/stories/$storyId/scenes');
    return response.data!.map((e) => SceneSummary.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// `402 scene_locked` (surfaced as `AppException.sceneLocked`) if this
  /// scene has an unlock cost the player hasn't paid yet — call
  /// [unlockScene] first.
  Future<Scene> getScene(String sceneId) async {
    final response = await _dio.get<Map<String, dynamic>>('/scenes/$sceneId');
    return Scene.fromJson(response.data!);
  }

  Future<PlayerProgress> submitChoice(String sceneId, String choiceId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/scenes/$sceneId/choice',
      data: ChoiceRequest(choiceId: choiceId).toJson(),
    );
    return PlayerProgress.fromJson(response.data!);
  }

  Future<void> unlockScene(String sceneId) async {
    await _dio.post<Map<String, dynamic>>('/scenes/$sceneId/unlock');
  }
}
