import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_models.freezed.dart';
part 'wallet_models.g.dart';

@freezed
class BalanceResponse with _$BalanceResponse {
  const factory BalanceResponse({required int balance}) = _BalanceResponse;

  factory BalanceResponse.fromJson(Map<String, dynamic> json) => _$BalanceResponseFromJson(json);
}

@freezed
class GrantRequest with _$GrantRequest {
  const factory GrantRequest({required int amount}) = _GrantRequest;

  factory GrantRequest.fromJson(Map<String, dynamic> json) => _$GrantRequestFromJson(json);
}

@freezed
class WalletTransaction with _$WalletTransaction {
  const factory WalletTransaction({
    required String id,
    required int amount,
    required String reason,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _WalletTransaction;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) => _$WalletTransactionFromJson(json);
}
