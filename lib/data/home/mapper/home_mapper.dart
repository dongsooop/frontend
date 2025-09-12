import 'package:dongsoop/data/home/model/home_response.dart';
import 'package:dongsoop/data/home/model/time_table_item_response.dart';
import 'package:dongsoop/data/home/model/schedule_item_response.dart';
import 'package:dongsoop/data/home/model/new_notice_item_response.dart';
import 'package:dongsoop/data/home/model/popular_recruit_item_response.dart';
import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

String _string(String? v) => (v ?? '').trim();

int _toInt(Object? v) {
  if (v is int) return v;
  if (v is String) return int.tryParse(v.trim()) ?? 0;
  return 0;
}

NoticeType _noticeTypeFrom(String? value) {
  switch (_string(value).toLowerCase()) {
    case 'official':
      return NoticeType.official;
    case 'department':
      return NoticeType.department;
    default:
      throw FormatException('$value');
  }
}

RecruitType _recruitTypeFrom(Object? value) {
  final typeString = _string(value?.toString());

  for (final recruitType in RecruitType.values) {
    if (recruitType.name == typeString) {
      return recruitType;
    }
  }

  throw FormatException('Unexpected RecruitType: $typeString');
}

ScheduleType _scheduleTypeFrom(String? value) {
  switch (_string(value).toLowerCase()) {
    case 'official':
      return ScheduleType.official;
    case 'member':
      return ScheduleType.member;
    default:
      throw FormatException('$value');
  }
}

extension HomeResponseMapper on HomeResponse {
  HomeEntity toEntity() {
    final timeTableSlots = timeTableItems.map((e) => e.toSlot()).toList();
    final schedule = scheduleItems.map((e) => e.toSchedule()).toList();
    final noticeList = newNoticeItems.map((e) => e.toNotice()).toList();
    final popularRecruitList = popularRecruitItems.map((e) => e.toRecruit()).toList();

    return HomeEntity(
      timeTable: timeTableSlots,
      schedule: schedule,
      notices: noticeList,
      popularRecruits: popularRecruitList,
    );
  }
}

extension TimeTableItemResponseMapper on TimeTableItemResponse {
  Slot toSlot() => (
  title: _string(title),
  startAt: _string(startAt),
  endAt: _string(endAt),
  );
}

extension ScheduleItemResponseMapper on ScheduleItemResponse {
  Schedule toSchedule() => (
  title: _string(title),
  startAt: _string(startAt),
  endAt: _string(endAt),
  type: _scheduleTypeFrom(type),
  );
}

extension NewNoticeItemResponseMapper on NewNoticeItemResponse {
  Notice toNotice() => (
  title: _string(title),
  link: _string(link),
  type: _noticeTypeFrom(type),
  );
}

extension PopularRecruitItemResponseMapper on PopularRecruitItemResponse {
  Recruit toRecruit() => (
  id: _toInt(id),
  title: _string(title),
  content: _string(content),
  tags: _string(tags),
  volunteer: _toInt(volunteer),
  type: _recruitTypeFrom(type),
  );
}
