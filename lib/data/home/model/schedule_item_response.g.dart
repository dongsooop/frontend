// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleItemResponse _$ScheduleItemResponseFromJson(
        Map<String, dynamic> json) =>
    ScheduleItemResponse(
      title: json['title'] as String,
      startAt: json['startAt'] as String,
      endAt: json['endAt'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$ScheduleItemResponseToJson(
        ScheduleItemResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'startAt': instance.startAt,
      'endAt': instance.endAt,
      'type': instance.type,
    };
