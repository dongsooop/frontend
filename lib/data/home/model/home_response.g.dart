// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeResponse _$HomeResponseFromJson(Map<String, dynamic> json) => HomeResponse(
      date: DateTime.parse(json['date'] as String),
      timeTableItems: (json['timeTableItem'] as List<dynamic>)
          .map((e) => TimeTableItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      calendarItems: (json['calendarItem'] as List<dynamic>)
          .map((e) => CalendarItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      newNoticeItems: (json['newNoticeItem'] as List<dynamic>)
          .map((e) => NewNoticeItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      popularRecruitItem: (json['popularRecruitItem'] as List<dynamic>)
          .map((e) =>
              PopularRecruitItemResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeResponseToJson(HomeResponse instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'timeTableItem': instance.timeTableItems,
      'calendarItem': instance.calendarItems,
      'newNoticeItem': instance.newNoticeItems,
      'popularRecruitItem': instance.popularRecruitItem,
    };
