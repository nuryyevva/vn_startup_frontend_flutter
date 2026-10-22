// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dialog_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DialogSessionImpl _$$DialogSessionImplFromJson(Map<String, dynamic> json) =>
    _$DialogSessionImpl(
      id: json['id'] as String,
      characterId: json['character_id'] as String,
      sceneId: json['scene_id'] as String,
      status: json['status'] as String,
      limitType: json['limit_type'] as String,
      limitValue: json['limit_value'] as int?,
      messageCount: json['message_count'] as int? ?? 0,
      messageCost: json['message_cost'] as int?,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] == null
          ? null
          : DateTime.parse(json['ended_at'] as String),
      endReason: json['end_reason'] as String?,
    );

Map<String, dynamic> _$$DialogSessionImplToJson(_$DialogSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'character_id': instance.characterId,
      'scene_id': instance.sceneId,
      'status': instance.status,
      'limit_type': instance.limitType,
      'limit_value': instance.limitValue,
      'message_count': instance.messageCount,
      'message_cost': instance.messageCost,
      'started_at': instance.startedAt.toIso8601String(),
      'ended_at': instance.endedAt?.toIso8601String(),
      'end_reason': instance.endReason,
    };
