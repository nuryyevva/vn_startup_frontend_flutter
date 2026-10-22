import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../config/app_config.dart';
import '../storage/secure_token_storage.dart';
import 'websocket_client.dart';

/// Null while not authenticated. Recreated whenever auth status
/// changes, so signing out cleanly tears down the old connection and
/// signing back in opens a fresh one.
final webSocketClientProvider = Provider<WebSocketClient?>((ref) {
  final authState = ref.watch(authStateProvider);
  if (authState.status != AuthStatus.authenticated) return null;

  final config = ref.watch(appConfigProvider);
  final tokenStorage = ref.watch(secureTokenStorageProvider);
  final client = WebSocketClient(wsBaseUrl: config.wsBaseUrl, getToken: tokenStorage.readAccessToken);
  unawaited(client.connect());
  ref.onDispose(() {
    unawaited(client.dispose());
  });
  return client;
});

/// Drives the small non-blocking "reconnecting…" indicator — never a
/// full-screen blocking overlay (see project spec §9).
final connectionStatusProvider = StreamProvider<WsConnectionStatus>((ref) {
  final client = ref.watch(webSocketClientProvider);
  if (client == null) return Stream.value(WsConnectionStatus.disconnected);
  return client.status;
});
