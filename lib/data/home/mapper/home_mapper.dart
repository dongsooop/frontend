import 'package:dongsoop/data/home/model/home_response.dart';
import 'package:dongsoop/data/home/model/time_table_item_response.dart';
import 'package:dongsoop/data/home/model/calendar_item_response.dart';
import 'package:dongsoop/data/home/model/new_notice_item_response.dart';
import 'package:dongsoop/data/home/model/popular_recruit_item_response.dart';
import 'package:dongsoop/domain/home/entity/home_entity.dart';

String _string(String? v) => (v ?? '').trim();

int _toInt(Object? v) {
  if (v is int) return v;
  if (v is String) return int.tryParse(v.trim()) ?? 0;
  return 0;
}

NoticeType _noticeTypeFrom(String? v) {
  switch (_string(v).toLowerCase()) {
    case 'official':
      return NoticeType.official;
    case 'department':
      return NoticeType.department;
    default:
      throw FormatException('Unexpected NoticeType: $v');
  }
}

extension HomeResponseMapper on HomeResponse {
  HomeEntity toEntity() {
    final timeTableSlots = timeTableItems.map((e) => e.toSlot()).toList();
    final calendarSlots = calendarItems.map((e) => e.toSlot()).toList();
    final noticeList = newNoticeItems.map((e) => e.toNotice()).toList();
    final popularRecruitList =
    popularRecruitItems.map((e) => e.toRecruit()).toList();

    return HomeEntity(
      timeTable: timeTableSlots,
      calendar: calendarSlots,
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

extension CalendarItemResponseMapper on CalendarItemResponse {
  Slot toSlot() => (
  title: _string(title),
  startAt: _string(startAt),
  endAt: _string(endAt),
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
  title: _string(title),
  content: _string(content),
  tags: _string(tags),
  volunteer: _toInt(volunteer),
  );
}
