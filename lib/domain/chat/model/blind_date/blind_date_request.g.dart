// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blind_date_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlindDateRequest _$BlindDateRequestFromJson(Map<String, dynamic> json) =>
    BlindDateRequest(
      sessionId: json['sessionId'] as String,
      message: json['message'] as String,
      senderId: (json['senderId'] as num).toInt(),
    );

Map<String, dynamic> _$BlindDateRequestToJson(BlindDateRequest instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'message': instance.message,
      'senderId': instance.senderId,
    };
