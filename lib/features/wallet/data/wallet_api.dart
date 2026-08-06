import 'package:dio/dio.dart';

import '../domain/models/wallet_models.dart';

/// Hand-written Dio wrapper for `/wallet/*` — see [AuthApi]'s doc comment
/// for why this isn't retrofit-generated.
class WalletApi {
  WalletApi(this._dio);

  final Dio _dio;

  Future<BalanceResponse> getBalance() async {
    final response = await _dio.get<Map<String, dynamic>>('/wallet/balance');
    return BalanceResponse.fromJson(response.data!);
  }

  /// Only reachable if the backend was started with `ENABLE_DEV_ENDPOINTS=true`
  /// — see `AppConfig.enableDevWalletGrant` and the shop feature's purchase
  /// button, which is the only caller of this.
  Future<WalletTransaction> devGrant(GrantRequest body) async {
    final response = await _dio.post<Map<String, dynamic>>('/dev/wallet/grant', data: body.toJson());
    return WalletTransaction.fromJson(response.data!);
  }
}
