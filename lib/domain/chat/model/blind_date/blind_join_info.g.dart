// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blind_join_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlindJoinInfo _$BlindJoinInfoFromJson(Map<String, dynamic> json) =>
    BlindJoinInfo(
      name: json['name'] as String,
      state: json['state'] as String,
      maxCount: (json['maxCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BlindJoinInfoToJson(BlindJoinInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'state': instance.state,
      'maxCount': instance.maxCount,
    };
