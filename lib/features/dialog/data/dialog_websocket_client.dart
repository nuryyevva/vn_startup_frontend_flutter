import 'dart:async';

import '../../../core/network/websocket_client.dart';
import '../domain/models/session_end_reason.dart';

/// Filters the app's single shared [WebSocketClient] stream down to the
/// three message types that matter for one dialog session
/// (`ai_response_chunk` / `ai_response_complete` / `session_ended`),
/// ignoring anything else (e.g. `ai_response_ready`, which belongs to the
/// scene-player's story-progress path, not free dialogue — project spec
/// §9 is explicit these two must not share a handler).
class DialogWebSocketClient {
  DialogWebSocketClient(this._client);

  final WebSocketClient _client;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  void subscribeToSession(
    String sessionId, {
    required void Function(String chunk) onChunk,
    required void Function(String fullText) onComplete,
    required void Function(SessionEndReason reason) onSessionEnded,
  }) {
    _subscription?.cancel();
    _subscription = _client.messages.listen((message) {
      if (message['session_id'] != sessionId) return;
      switch (message['type']) {
        case 'ai_response_chunk':
          final chunk = message['chunk'];
          if (chunk is String) onChunk(chunk);
        case 'ai_response_complete':
          final text = message['text'];
          if (text is String) onComplete(text);
        case 'session_ended':
          final reason = sessionEndReasonFromWire(message['reason'] as String?);
          if (reason != null) onSessionEnded(reason);
      }
    });
  }

  void unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}
