abstract class WalletRepository {
  Future<int> getBalance();

  /// Grants [amount] diamonds via the dev-only endpoint. Returns the
  /// amount granted (not the new balance — the backend's transaction
  /// response doesn't include a running balance, see wallet module docs).
  Future<int> devGrant(int amount);
}
