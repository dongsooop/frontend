// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_enable_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationEnableModel _$NotificationEnableModelFromJson(
        Map<String, dynamic> json) =>
    NotificationEnableModel(
      deviceToken: json['deviceToken'] as String,
      notificationType: json['notificationType'] as String,
    );

Map<String, dynamic> _$NotificationEnableModelToJson(
        NotificationEnableModel instance) =>
    <String, dynamic>{
      'deviceToken': instance.deviceToken,
      'notificationType': instance.notificationType,
    };
