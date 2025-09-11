import 'package:dongsoop/data/home/model/calendar_item_response.dart';
import 'package:dongsoop/data/home/model/new_notice_item_response.dart';
import 'package:dongsoop/data/home/model/popular_recruit_item_response.dart';
import 'package:dongsoop/data/home/model/time_table_item_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_response.freezed.dart';
part 'home_response.g.dart';

@freezed
@JsonSerializable()
class HomeResponse with _$HomeResponse {
  @Default([]) @JsonKey(name: 'timetable')
  final List<TimeTableItemResponse> timeTableItems;
  @Default([]) @JsonKey(name: 'schedules')
  final List<CalendarItemResponse> calendarItems;
  @Default([]) @JsonKey(name: 'notices')
  final List<NewNoticeItemResponse> newNoticeItems;
  @Default([]) @JsonKey(name: 'popular_recruitments')
  final List<PopularRecruitItemResponse> popularRecruitItems;

  const HomeResponse({
    required this.timeTableItems,
    required this.calendarItems,
    required this.newNoticeItems,
    required this.popularRecruitItems,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseFromJson(json);
}