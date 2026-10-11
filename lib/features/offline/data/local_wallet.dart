import '../../../core/network/error_mapper.dart';
import '../../wallet/data/wallet_repository.dart';
import 'local_store.dart';

/// The diamond wallet kept on the device. There are no real purchases
/// offline: the shop's "get" button simply adds diamonds (the same path the
/// dev-grant flow uses against the server).
class LocalWallet implements WalletRepository {
  LocalWallet(this._store);

  final LocalStore _store;

  static const _balanceKey = 'wallet.balance';
  static const _spentKey = 'wallet.spent';

  int get balance => _store.readInt(_balanceKey);

  /// Total diamonds ever spent — feeds the spending achievements.
  int get spent => _store.readInt(_spentKey);

  @override
  Future<int> getBalance() async => balance;

  @override
  Future<int> devGrant(int amount) async {
    await _store.writeInt(_balanceKey, balance + amount);
    return amount;
  }

  /// Takes [amount] diamonds, or throws [InsufficientDiamondsException] and
  /// takes nothing.
  Future<void> debit(int amount) async {
    if (amount <= 0) return;
    if (balance < amount) throw const AppException.insufficientDiamonds();
    await _store.writeInt(_balanceKey, balance - amount);
    await _store.writeInt(_spentKey, spent + amount);
  }
}
