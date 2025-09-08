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
  final DateTime date;
  @JsonKey(name: 'timeTableItem')
  final List<TimeTableItemResponse> timeTableItems;
  @JsonKey(name: 'calendarItem')
  final List<CalendarItemResponse> calendarItems;
  @JsonKey(name: 'newNoticeItem')
  final List<NewNoticeItemResponse> newNoticeItems;
  @JsonKey(name: 'popularRecruitItem')
  final List<PopularRecruitItemResponse> popularRecruitItem;

  const HomeResponse({
    required this.date,
    required this.timeTableItems,
    required this.calendarItems,
    required this.newNoticeItems,
    required this.popularRecruitItem,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseFromJson(json);
}