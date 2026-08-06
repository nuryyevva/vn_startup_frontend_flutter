// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DialogMessageImpl _$$DialogMessageImplFromJson(Map<String, dynamic> json) =>
    _$DialogMessageImpl(
      id: json['id'] as String,
      sender: json['sender'] as String,
      text: json['text'] as String,
      isStreaming: json['isStreaming'] as bool? ?? false,
      costDiamonds: json['cost_diamonds'] as int? ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      remainingLimit: json['remaining_limit'] as int?,
    );

Map<String, dynamic> _$$DialogMessageImplToJson(_$DialogMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'text': instance.text,
      'isStreaming': instance.isStreaming,
      'cost_diamonds': instance.costDiamonds,
      'created_at': instance.createdAt?.toIso8601String(),
      'remaining_limit': instance.remainingLimit,
    };
