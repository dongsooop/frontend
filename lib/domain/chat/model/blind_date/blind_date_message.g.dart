// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blind_date_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlindDateMessage _$BlindDateMessageFromJson(Map<String, dynamic> json) =>
    BlindDateMessage(
      message: json['message'] as String,
      memberId: (json['memberId'] as num).toInt(),
      name: json['name'] as String,
      sendAt: DateTime.parse(json['sendAt'] as String),
      type: json['type'] as String,
    );

Map<String, dynamic> _$BlindDateMessageToJson(BlindDateMessage instance) =>
    <String, dynamic>{
      'message': instance.message,
      'memberId': instance.memberId,
      'name': instance.name,
      'sendAt': instance.sendAt.toIso8601String(),
      'type': instance.type,
    };
