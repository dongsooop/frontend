// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarListModel _$CalendarListModelFromJson(Map<String, dynamic> json) =>
    CalendarListModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      location: json['location'] as String,
      startAt: DateTime.parse(json['startAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      type: json['type'] as String,
    );

Map<String, dynamic> _$CalendarListModelToJson(CalendarListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'location': instance.location,
      'startAt': instance.startAt.toIso8601String(),
      'endAt': instance.endAt.toIso8601String(),
      'type': instance.type,
    };
