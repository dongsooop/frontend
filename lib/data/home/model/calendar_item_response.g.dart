// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarItemResponse _$CalendarItemResponseFromJson(
        Map<String, dynamic> json) =>
    CalendarItemResponse(
      title: json['title'] as String,
      startAt: json['startAt'] as String,
      endAt: json['endAt'] as String,
    );

Map<String, dynamic> _$CalendarItemResponseToJson(
        CalendarItemResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'startAt': instance.startAt,
      'endAt': instance.endAt,
    };
