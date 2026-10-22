import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_token_storage.dart';
import '../../data/auth_api.dart';
import '../../data/auth_repository.dart';
import '../../data/auth_repository_impl.dart';
import '../../domain/models/auth_user.dart';

enum AuthStatus {
  /// Startup only: haven't checked local storage for a session yet. The
  /// router keeps the splash/loading state until this resolves.
  unknown,
  unauthenticated,
  authenticated,
}

class AuthState {
  const AuthState({required this.status, this.user});

  final AuthStatus status;
  final AuthUser? user;

  static const initial = AuthState(status: AuthStatus.unknown);

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier(this._repository) : super(AuthState.initial) {
    unawaited(_bootstrap());
  }

  final AuthRepository _repository;

  Future<void> _bootstrap() async {
    final hasSession = await _repository.hasStoredSession();
    state = AuthState(status: hasSession ? AuthStatus.authenticated : AuthStatus.unauthenticated);
  }

  Future<void> register(String email, String password) async {
    final user = await _repository.register(email, password);
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  Future<void> login(String email, String password) async {
    final user = await _repository.login(email, password);
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  Future<void> signOut() async {
    await _repository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authApiProvider = Provider<AuthApi>((ref) => AuthApi(ref.watch(dioProvider)));

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(api: ref.watch(authApiProvider), tokenStorage: ref.watch(secureTokenStorageProvider));
});

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref.watch(authRepositoryProvider));
});
