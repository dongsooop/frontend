// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_table_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeTableItemResponse _$TimeTableItemResponseFromJson(
        Map<String, dynamic> json) =>
    TimeTableItemResponse(
      title: json['title'] as String,
      startAt: json['startAt'] as String,
      endAt: json['endAt'] as String,
    );

Map<String, dynamic> _$TimeTableItemResponseToJson(
        TimeTableItemResponse instance) =>
    <String, dynamic>{
      'title': instance.title,
      'startAt': instance.startAt,
      'endAt': instance.endAt,
    };
