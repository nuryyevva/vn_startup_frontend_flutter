import '../domain/models/wallet_models.dart';
import 'wallet_api.dart';
import 'wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl(this._api);

  final WalletApi _api;

  @override
  Future<int> getBalance() async {
    final response = await _api.getBalance();
    return response.balance;
  }

  @override
  Future<int> devGrant(int amount) async {
    final transaction = await _api.devGrant(GrantRequest(amount: amount));
    return transaction.amount;
  }
}
