// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timetable _$TimetableFromJson(Map<String, dynamic> json) => Timetable(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      professor: json['professor'] as String,
      location: json['location'] as String,
      week: $enumDecode(_$WeekDayEnumMap, json['week']),
      startAt: json['startAt'] as String,
      endAt: json['endAt'] as String,
    );

Map<String, dynamic> _$TimetableToJson(Timetable instance) => <String, dynamic>{
      'id': instance.id,
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
