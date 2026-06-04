// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_recruit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationRecruitModel _$NotificationRecruitModelFromJson(
        Map<String, dynamic> json) =>
    NotificationRecruitModel(
      deviceToken: json['deviceToken'] as String,
      targetState: json['targetState'] as bool,
    );

Map<String, dynamic> _$NotificationRecruitModelToJson(
        NotificationRecruitModel instance) =>
    <String, dynamic>{
      'deviceToken': instance.deviceToken,
      'targetState': instance.targetState,
    };
