// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture_AI.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LectureAi _$LectureAiFromJson(Map<String, dynamic> json) => LectureAi(
      name: json['name'] as String,
      professor: json['professor'] as String?,
      location: json['location'] as String?,
      week: $enumDecode(_$WeekDayEnumMap, json['week']),
      startAt: json['startAt'] as String,
      endAt: json['endAt'] as String,
    );

Map<String, dynamic> _$LectureAiToJson(LectureAi instance) => <String, dynamic>{
      'name': instance.name,
      'professor': instance.professor,
      'location': instance.location,
      'week': _$WeekDayEnumMap[instance.week]!,
      'startAt': instance.startAt,
      'endAt': instance.endAt,
    };

const _$WeekDayEnumMap = {
  WeekDay.MONDAY: 'MONDAY',
  WeekDay.TUESDAY: 'TUESDAY',
  WeekDay.WEDNESDAY: 'WEDNESDAY',
  WeekDay.THURSDAY: 'THURSDAY',
  WeekDay.FRIDAY: 'FRIDAY',
};
