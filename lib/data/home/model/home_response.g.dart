// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeResponse _$HomeResponseFromJson(Map<String, dynamic> json) => HomeResponse(
      timeTableItems: (json['timetable'] as List<dynamic>)
          .map((e) => TimeTableItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      scheduleItems: (json['schedules'] as List<dynamic>)
          .map((e) => ScheduleItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      newNoticeItems: (json['notices'] as List<dynamic>)
          .map((e) => NewNoticeItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      popularRecruitItems: (json['popular_recruitments'] as List<dynamic>)
          .map((e) =>
              PopularRecruitItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeResponseToJson(HomeResponse instance) =>
    <String, dynamic>{
      'timetable': instance.timeTableItems,
      'schedules': instance.scheduleItems,
      'notices': instance.newNoticeItems,
      'popular_recruitments': instance.popularRecruitItems,
    };
