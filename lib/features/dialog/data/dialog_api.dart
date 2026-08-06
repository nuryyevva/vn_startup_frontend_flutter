import 'package:dio/dio.dart';

import '../domain/models/dialog_message.dart';
import '../domain/models/dialog_session.dart';

/// Hand-written Dio wrapper for `/dialog/sessions/*` — see `AuthApi`'s doc
/// comment for why this isn't retrofit-generated.
class DialogApi {
  DialogApi(this._dio);

  final Dio _dio;

  Future<DialogSession> startSession(String characterId, String sceneId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/dialog/sessions',
      data: {'character_id': characterId, 'scene_id': sceneId},
    );
    return DialogSession.fromJson(response.data!);
  }

  Future<DialogMessage> sendMessage(String sessionId, String text) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/dialog/sessions/$sessionId/messages',
      data: {'text': text},
    );
    return DialogMessage.fromJson(response.data!);
  }

  Future<DialogSession> endSession(String sessionId) async {
    final response = await _dio.post<Map<String, dynamic>>('/dialog/sessions/$sessionId/end');
    return DialogSession.fromJson(response.data!);
  }
}
