import 'package:dongsoop/data/home/model/schedule_item_response.dart';
import 'package:dongsoop/data/home/model/new_notice_item_response.dart';
import 'package:dongsoop/data/home/model/popular_recruit_item_response.dart';
import 'package:dongsoop/data/home/model/time_table_item_response.dart';
import 'package:dongsoop/data/home/model/home_eclass_assignment_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_response.freezed.dart';
part 'home_response.g.dart';

@freezed
@JsonSerializable()
class HomeResponse with _$HomeResponse {
  @Default([]) @JsonKey(name: 'timetable')
  final List<TimeTableItemResponse> timeTableItems;
  @Default([]) @JsonKey(name: 'schedules')
  final List<ScheduleItemResponse> scheduleItems;
  @Default([]) @JsonKey(name: 'notices')
  final List<NewNoticeItemResponse> newNoticeItems;
  @Default([]) @JsonKey(name: 'popular_recruitments')
  final List<PopularRecruitItemResponse> popularRecruitItems;
  @JsonKey(name: 'eclass_assignment')
  final HomeEclassAssignmentResponse? eclassAssignment;

  const HomeResponse({
    required this.timeTableItems,
    required this.scheduleItems,
    required this.newNoticeItems,
    required this.popularRecruitItems,
    this.eclassAssignment,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HomeResponseToJson(this);
}
