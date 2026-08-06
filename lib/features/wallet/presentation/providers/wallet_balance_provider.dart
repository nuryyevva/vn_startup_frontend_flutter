import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/wallet_api.dart';
import '../../data/wallet_repository.dart';
import '../../data/wallet_repository_impl.dart';

final walletApiProvider = Provider<WalletApi>((ref) => WalletApi(ref.watch(dioProvider)));

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepositoryImpl(ref.watch(walletApiProvider));
});

/// Reactive diamond balance, shared by profile/shop/scene_player headers.
/// Not a one-shot snapshot — [refresh] re-fetches from the server, while
/// [applyOptimisticDelta] updates the UI instantly after a spend/grant the
/// caller already knows succeeded, without waiting on a round-trip.
class WalletBalanceNotifier extends StateNotifier<AsyncValue<int>> {
  WalletBalanceNotifier(this._repository) : super(const AsyncValue.loading()) {
    unawaited(refresh());
  }

  final WalletRepository _repository;

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.getBalance);
  }

  void applyOptimisticDelta(int delta) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(current + delta);
  }
}

final walletBalanceProvider = StateNotifierProvider<WalletBalanceNotifier, AsyncValue<int>>((ref) {
  return WalletBalanceNotifier(ref.watch(walletRepositoryProvider));
});
