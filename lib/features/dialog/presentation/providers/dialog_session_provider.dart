import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/websocket_provider.dart';
import '../../data/dialog_api.dart';
import '../../data/dialog_repository.dart';
import '../../data/dialog_repository_impl.dart';
import '../../data/dialog_websocket_client.dart';
import '../../domain/models/dialog_message.dart';
import '../../domain/models/dialog_session.dart';
import '../../domain/models/session_end_reason.dart';
import '../../domain/usecases/end_dialog_session.dart';
import '../../domain/usecases/send_dialog_message.dart';
import '../../domain/usecases/start_dialog_session.dart';

class DialogSessionState {
  const DialogSessionState({
    required this.session,
    required this.messages,
    this.streamingBuffer,
    this.isSessionEnded = false,
    this.endReason,
    this.remainingLimit,
    this.isSending = false,
  });

  final DialogSession session;
  final List<DialogMessage> messages;

  /// Text of the character's reply that's still streaming in — rendered
  /// directly, no typewriter animation layered on top (project spec §8.5:
  /// "это естественное следствие потоковой доставки").
  final String? streamingBuffer;
  final bool isSessionEnded;
  final SessionEndReason? endReason;

  /// Only ever set from the server's response to the user's own message —
  /// never computed client-side (project spec §8.5).
  final int? remainingLimit;
  final bool isSending;

  DialogSessionState copyWith({
    DialogSession? session,
    List<DialogMessage>? messages,
    String? streamingBuffer,
    bool clearStreamingBuffer = false,
    bool? isSessionEnded,
    SessionEndReason? endReason,
    int? remainingLimit,
    bool? isSending,
  }) {
    return DialogSessionState(
      session: session ?? this.session,
      messages: messages ?? this.messages,
      streamingBuffer: clearStreamingBuffer ? null : (streamingBuffer ?? this.streamingBuffer),
      isSessionEnded: isSessionEnded ?? this.isSessionEnded,
      endReason: endReason ?? this.endReason,
      remainingLimit: remainingLimit ?? this.remainingLimit,
      isSending: isSending ?? this.isSending,
    );
  }
}

/// State is null until [start] resolves — a dedicated "not started" case
/// rather than a sentinel session, since `FreeDialogScreen` always calls
/// [start] immediately on mount and has nothing meaningful to render
/// before that.
class DialogSessionNotifier extends StateNotifier<DialogSessionState?> {
  DialogSessionNotifier({
    required StartDialogSession startDialogSession,
    required SendDialogMessage sendDialogMessage,
    required EndDialogSession endDialogSession,
    required DialogRepository repository,
  }) : _startDialogSession = startDialogSession,
       _sendDialogMessage = sendDialogMessage,
       _endDialogSession = endDialogSession,
       _repository = repository,
       super(null);

  final StartDialogSession _startDialogSession;
  final SendDialogMessage _sendDialogMessage;
  final EndDialogSession _endDialogSession;
  final DialogRepository _repository;

  Future<void> start(String characterId, String sceneId) async {
    final session = await _startDialogSession(characterId, sceneId);
    state = DialogSessionState(session: session, messages: const [], remainingLimit: session.limitValue);
    _repository.subscribeToUpdates(
      session.id,
      onChunk: _onChunk,
      onComplete: _onComplete,
      onSessionEnded: _onSessionEnded,
    );
  }

  Future<void> sendMessage(String text) async {
    final current = state;
    if (current == null || current.isSessionEnded) return;

    final optimisticMessage = DialogMessage(id: 'local-${DateTime.now().microsecondsSinceEpoch}', sender: 'user', text: text);
    state = current.copyWith(messages: [...current.messages, optimisticMessage], isSending: true);

    try {
      final sent = await _sendDialogMessage(current.session.id, text);
      final updated = state;
      if (updated == null) return;
      state = updated.copyWith(isSending: false, remainingLimit: sent.remainingLimit ?? updated.remainingLimit);
    } catch (_) {
      final updated = state;
      if (updated == null) return;
      state = updated.copyWith(isSending: false);
      rethrow;
    }
  }

  void _onChunk(String chunk) {
    final current = state;
    if (current == null) return;
    state = current.copyWith(streamingBuffer: (current.streamingBuffer ?? '') + chunk);
  }

  void _onComplete(String fullText) {
    final current = state;
    if (current == null) return;
    final finalMessage = DialogMessage(id: 'character-${DateTime.now().microsecondsSinceEpoch}', sender: 'character', text: fullText);
    state = current.copyWith(messages: [...current.messages, finalMessage], clearStreamingBuffer: true);
  }

  void _onSessionEnded(SessionEndReason reason) {
    final current = state;
    if (current == null) return;
    state = current.copyWith(isSessionEnded: true, endReason: reason);
  }

  /// User-initiated exit (closing the overlay) — the resulting session's
  /// `end_reason` will be `user_left`.
  Future<void> leave() async {
    final current = state;
    if (current == null) return;
    try {
      await _endDialogSession(current.session.id);
    } catch (_) {
      // Best-effort — the overlay is closing regardless.
    }
    _repository.unsubscribe();
  }

  @override
  void dispose() {
    _repository.unsubscribe();
    super.dispose();
  }
}

final dialogApiProvider = Provider<DialogApi>((ref) => DialogApi(ref.watch(dioProvider)));

final dialogWebSocketClientProvider = Provider<DialogWebSocketClient?>((ref) {
  final client = ref.watch(webSocketClientProvider);
  if (client == null) return null;
  return DialogWebSocketClient(client);
});

final dialogRepositoryProvider = Provider<DialogRepository?>((ref) {
  final wsClient = ref.watch(dialogWebSocketClientProvider);
  if (wsClient == null) return null;
  return DialogRepositoryImpl(api: ref.watch(dialogApiProvider), wsClient: wsClient);
});

/// `autoDispose` so every time `FreeDialogScreen` is opened it starts from
/// a clean slate — the overlay is mounted/unmounted by `scene_player`, not
/// routed to, so there's no route-based disposal to rely on instead.
final dialogSessionProvider = StateNotifierProvider.autoDispose<DialogSessionNotifier, DialogSessionState?>((ref) {
  final repository = ref.watch(dialogRepositoryProvider);
  if (repository == null) {
    throw StateError('dialogSessionProvider read while unauthenticated (no WebSocket connection)');
  }
  return DialogSessionNotifier(
    startDialogSession: StartDialogSession(repository),
    sendDialogMessage: SendDialogMessage(repository),
    endDialogSession: EndDialogSession(repository),
    repository: repository,
  );
});
