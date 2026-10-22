import 'dart:async';

import '../../../core/network/error_mapper.dart';
import '../../wallet/data/wallet_repository.dart';
import 'local_store.dart';

/// The diamond wallet kept on the device, under the same rules as an account
/// on the server: it starts with [startingBalance] diamonds (also applied
/// once to wallets from older builds), and getting more is "coming soon".
class LocalWallet implements WalletRepository {
  LocalWallet(this._store);

  final LocalStore _store;

  static const _balanceKey = 'wallet.balance';
  static const _spentKey = 'wallet.spent';
  static const _startedKey = 'wallet.startingBalanceApplied';

  /// What every wallet starts with (the server's wallet.StartingBalance).
  static const startingBalance = 600;

  int get balance {
    if (_store.readInt(_startedKey) == 0) {
      unawaited(_store.writeInt(_balanceKey, startingBalance));
      unawaited(_store.writeInt(_startedKey, 1));
      return startingBalance;
    }
    return _store.readInt(_balanceKey);
  }

  /// Total diamonds ever spent — feeds the spending achievements.
  int get spent => _store.readInt(_spentKey);

  @override
  Future<int> getBalance() async => balance;

  @override
  Future<int> devGrant(int amount) async => throw const AppException.topUpUnavailable();

  /// Takes [amount] diamonds, or throws [InsufficientDiamondsException] and
  /// takes nothing.
  Future<void> debit(int amount) async {
    if (amount <= 0) return;
    if (balance < amount) throw const AppException.insufficientDiamonds();
    await _store.writeInt(_balanceKey, balance - amount);
    await _store.writeInt(_spentKey, spent + amount);
  }
}
