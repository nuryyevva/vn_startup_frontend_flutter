import '../domain/models/dialog_message.dart';
import '../domain/models/dialog_session.dart';
import '../domain/models/session_end_reason.dart';

abstract class DialogRepository {
  Future<DialogSession> startSession(String characterId, String sceneId);
  Future<DialogMessage> sendMessage(String sessionId, String text);

  /// Manual exit — `reason` on the resulting ended session will be
  /// `user_left`.
  Future<void> endSession(String sessionId);

  void subscribeToUpdates(
    String sessionId, {
    required void Function(String chunk) onChunk,
    required void Function(String fullText) onComplete,
    required void Function(SessionEndReason reason) onSessionEnded,
  });

  void unsubscribe();
}
