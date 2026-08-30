// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_token_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceTokenRequest _$DeviceTokenRequestFromJson(Map<String, dynamic> json) =>
    DeviceTokenRequest(
      deviceToken: json['deviceToken'] as String,
      fid: json['fid'] as String?,
      type: json['type'] as String,
    );

Map<String, dynamic> _$DeviceTokenRequestToJson(DeviceTokenRequest instance) =>
    <String, dynamic>{
      'deviceToken': instance.deviceToken,
      'fid': instance.fid,
      'type': instance.type,
    };
