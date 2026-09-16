import 'package:dongsoop/data/home/model/home_response.dart';
import 'package:dongsoop/data/home/model/time_table_item_response.dart';
import 'package:dongsoop/data/home/model/schedule_item_response.dart';
import 'package:dongsoop/data/home/model/new_notice_item_response.dart';
import 'package:dongsoop/data/home/model/popular_recruit_item_response.dart';
import 'package:dongsoop/data/home/model/home_eclass_assignment_response.dart';
import 'package:dongsoop/data/home/model/home_eclass_upcoming_assignment_response.dart';
import 'package:dongsoop/data/eclass/mapper/eclass_link_mapper.dart';
import 'package:dongsoop/domain/home/entity/home_entity.dart';
import 'package:dongsoop/domain/home/entity/home_eclass_assignment_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/eclass/enum/eclass_link_status.dart';

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
      eclassAssignment: eclassAssignment?.toEntity(),
    );
  }
}

extension HomeEclassAssignmentResponseMapper on HomeEclassAssignmentResponse {
  HomeEclassAssignmentEntity toEntity() {
    final mappedStatus = mapEclassLinkStatus(status);
    final List<HomeEclassUpcomingAssignmentEntity> mappedUpcoming =
        List.unmodifiable(
      (upcoming ?? const <HomeEclassUpcomingAssignmentResponse>[])
          .map((assignment) => assignment.toEntity()),
    );

    if (!linked && mappedStatus != null) {
      throw const FormatException(
        'Unlinked home Eclass response contains a status.',
      );
    }
    if (linked && mappedStatus == null) {
      throw const FormatException(
        'Linked home Eclass response has no status.',
      );
    }
    if (upcomingCount < 0 || mappedUpcoming.length > 3) {
      throw const FormatException('Invalid home Eclass assignment count.');
    }
    if (mappedUpcoming.any((assignment) => assignment.submitted)) {
      throw const FormatException(
        'Home Eclass response contains a submitted assignment.',
      );
    }
    if (mappedUpcoming.length > upcomingCount) {
      throw const FormatException(
        'Home Eclass response has more summaries than assignments.',
      );
    }
    if ((!linked || mappedStatus == EclassLinkStatus.expired) &&
        (upcomingCount != 0 || mappedUpcoming.isNotEmpty)) {
      throw const FormatException(
        'Inactive home Eclass response contains assignments.',
      );
    }

    final legacyAssignment = _legacyAssignmentOrNull();
    final primaryAssignment =
        mappedUpcoming.isNotEmpty ? mappedUpcoming.first : legacyAssignment;
    if (upcomingCount == 0 && primaryAssignment != null) {
      throw const FormatException(
        'Home Eclass response has a summary without assignments.',
      );
    }

    return HomeEclassAssignmentEntity(
      linked: linked,
      status: mappedStatus,
      upcomingCount: upcomingCount,
      upcoming: mappedUpcoming,
      primaryAssignment: primaryAssignment,
    );
  }

  HomeEclassUpcomingAssignmentEntity? _legacyAssignmentOrNull() {
    final values = <Object?>[
      nearestCourseName,
      nearestTitle,
      nearestDueAt,
      nearestDDay,
    ];
    final providedCount = values.where((value) => value != null).length;

    if (providedCount == 0) return null;
    if (providedCount != values.length) {
      throw const FormatException(
        'Home Eclass nearest assignment is incomplete.',
      );
    }

    return HomeEclassUpcomingAssignmentEntity(
      courseName: nearestCourseName!,
      title: nearestTitle!,
      dueAt: nearestDueAt!,
      dDay: nearestDDay!,
      submitted: false,
    );
  }
}

extension HomeEclassUpcomingAssignmentResponseMapper
    on HomeEclassUpcomingAssignmentResponse {
  HomeEclassUpcomingAssignmentEntity toEntity() {
    return HomeEclassUpcomingAssignmentEntity(
      courseName: courseName,
      title: title,
      dueAt: dueAt,
      dDay: dDay,
      submitted: submitted,
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
  id: id,
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
