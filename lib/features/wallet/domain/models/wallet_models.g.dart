// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BalanceResponseImpl _$$BalanceResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$BalanceResponseImpl(
      balance: json['balance'] as int,
    );

Map<String, dynamic> _$$BalanceResponseImplToJson(
        _$BalanceResponseImpl instance) =>
    <String, dynamic>{
      'balance': instance.balance,
    };

_$GrantRequestImpl _$$GrantRequestImplFromJson(Map<String, dynamic> json) =>
    _$GrantRequestImpl(
      amount: json['amount'] as int,
    );

Map<String, dynamic> _$$GrantRequestImplToJson(_$GrantRequestImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
    };

_$WalletTransactionImpl _$$WalletTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletTransactionImpl(
      id: json['id'] as String,
      amount: json['amount'] as int,
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$WalletTransactionImplToJson(
        _$WalletTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'reason': instance.reason,
      'created_at': instance.createdAt.toIso8601String(),
    };
