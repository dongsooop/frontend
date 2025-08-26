// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LectureRequest _$LectureRequestFromJson(Map<String, dynamic> json) =>
    LectureRequest(
      name: json['name'] as String,
      professor: json['professor'] as String,
      location: json['location'] as String,
      week: $enumDecode(_$WeekDayEnumMap, json['week']),
      startAt: json['startAt'] as String,
      endAt: json['endAt'] as String,
      year: (json['year'] as num).toInt(),
      semester: json['semester'] as String,
    );

Map<String, dynamic> _$LectureRequestToJson(LectureRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'professor': instance.professor,
      'location': instance.location,
      'week': _$WeekDayEnumMap[instance.week]!,
      'startAt': instance.startAt,
      'endAt': instance.endAt,
      'year': instance.year,
      'semester': instance.semester,
    };

const _$WeekDayEnumMap = {
  WeekDay.MONDAY: 'MONDAY',
  WeekDay.TUESDAY: 'TUESDAY',
  WeekDay.WEDNESDAY: 'WEDNESDAY',
  WeekDay.THURSDAY: 'THURSDAY',
  WeekDay.FRIDAY: 'FRIDAY',
};
