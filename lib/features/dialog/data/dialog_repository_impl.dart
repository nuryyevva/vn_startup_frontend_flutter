import '../domain/models/dialog_message.dart';
import '../domain/models/dialog_session.dart';
import '../domain/models/session_end_reason.dart';
import 'dialog_api.dart';
import 'dialog_repository.dart';
import 'dialog_websocket_client.dart';

class DialogRepositoryImpl implements DialogRepository {
  DialogRepositoryImpl({required DialogApi api, required DialogWebSocketClient wsClient}) : _api = api, _wsClient = wsClient;

  final DialogApi _api;
  final DialogWebSocketClient _wsClient;

  @override
  Future<DialogSession> startSession(String characterId, String sceneId) => _api.startSession(characterId, sceneId);

  @override
  Future<DialogMessage> sendMessage(String sessionId, String text) => _api.sendMessage(sessionId, text);

  @override
  Future<void> endSession(String sessionId) => _api.endSession(sessionId);

  @override
  void subscribeToUpdates(
    String sessionId, {
    required void Function(String chunk) onChunk,
    required void Function(String fullText) onComplete,
    required void Function(SessionEndReason reason) onSessionEnded,
  }) {
    _wsClient.subscribeToSession(sessionId, onChunk: onChunk, onComplete: onComplete, onSessionEnded: onSessionEnded);
  }

  @override
  void unsubscribe() => _wsClient.unsubscribe();
}
