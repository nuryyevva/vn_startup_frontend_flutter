import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

enum WsConnectionStatus { connecting, connected, reconnecting, disconnected }

/// One persistent `GET /ws?token=` connection for the whole app session
/// (see project spec §9) — reconnects with exponential backoff on drop,
/// and re-reads the access token from storage on every (re)connect
/// attempt via [getToken] so a silent refresh is picked up naturally the
/// next time the socket needs to reconnect.
class WebSocketClient {
  WebSocketClient({required this.wsBaseUrl, required this.getToken});

  final String wsBaseUrl;
  final Future<String?> Function() getToken;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _statusController = StreamController<WsConnectionStatus>.broadcast();
  int _retryCount = 0;
  bool _disposed = false;
  Timer? _reconnectTimer;

  Stream<Map<String, dynamic>> get messages => _messageController.stream;
  Stream<WsConnectionStatus> get status => _statusController.stream;

  Future<void> connect() async {
    if (_disposed) return;
    _statusController.add(_retryCount == 0 ? WsConnectionStatus.connecting : WsConnectionStatus.reconnecting);

    final token = await getToken();
    if (token == null) {
      _statusController.add(WsConnectionStatus.disconnected);
      return;
    }

    final base = Uri.parse(wsBaseUrl);
    final prefix = base.path.endsWith('/') ? base.path.substring(0, base.path.length - 1) : base.path;
    final uri = base.replace(path: '$prefix/ws', queryParameters: {'token': token});
    try {
      final channel = WebSocketChannel.connect(uri);
      await channel.ready;
      if (_disposed) {
        await channel.sink.close();
        return;
      }
      _channel = channel;
      _retryCount = 0;
      _statusController.add(WsConnectionStatus.connected);
      _subscription = channel.stream.listen(_onData, onDone: _scheduleReconnect, onError: (_) => _scheduleReconnect());
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void _onData(dynamic data) {
    if (data is! String) return;
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) {
        _messageController.add(decoded);
      }
    } catch (_) {
      // Malformed frame — drop it rather than crash the socket loop.
    }
  }

  void _scheduleReconnect() {
    if (_disposed) return;
    _channel = null;
    _statusController.add(WsConnectionStatus.reconnecting);
    _retryCount = (_retryCount + 1).clamp(0, 6);
    final delayMs = 500 * (1 << _retryCount);
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(milliseconds: delayMs), connect);
  }

  Future<void> dispose() async {
    _disposed = true;
    _reconnectTimer?.cancel();
    await _subscription?.cancel();
    await _channel?.sink.close();
    await _messageController.close();
    await _statusController.close();
  }
}
