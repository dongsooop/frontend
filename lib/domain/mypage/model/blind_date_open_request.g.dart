// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blind_date_open_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlindDateOpenRequest _$BlindDateOpenRequestFromJson(
        Map<String, dynamic> json) =>
    BlindDateOpenRequest(
      expiredDate: DateTime.parse(json['expiredDate'] as String),
      maxSessionMemberCount: (json['maxSessionMemberCount'] as num).toInt(),
    );

Map<String, dynamic> _$BlindDateOpenRequestToJson(
        BlindDateOpenRequest instance) =>
    <String, dynamic>{
      'expiredDate': instance.expiredDate.toIso8601String(),
      'maxSessionMemberCount': instance.maxSessionMemberCount,
    };
