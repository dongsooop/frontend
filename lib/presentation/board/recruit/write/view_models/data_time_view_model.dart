import 'package:dongsoop/presentation/board/recruit/write/state/date_time_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 모집 시작/마감 날짜 및 시간 선택을 위한 ViewModel
// 상태: [DateTimeSelectorState]
class DateTimeSelectorViewModel extends StateNotifier<DateTimeSelectorState> {
  DateTimeSelectorViewModel()
      : super(
          DateTimeSelectorState(
            startDateTime: _roundUpTo10(DateTime.now()),
            endDateTime:
                _roundUpTo10(DateTime.now()).add(const Duration(days: 1)),
            startTimePicked: false,
            endTimePicked: false,
          ),
        );

  // 현재 시간 기준으로 10분 단위로 올림한 시간을 반환
  static DateTime _roundUpTo10(DateTime dt) {
    final roundedMinute = ((dt.minute + 9) ~/ 10) * 10;
    if (roundedMinute == 60) {
      dt = dt.add(const Duration(hours: 1));
      return DateTime(dt.year, dt.month, dt.day, dt.hour, 0);
    }
    return DateTime(dt.year, dt.month, dt.day, dt.hour, roundedMinute);
  }

  // 날짜 선택 시 호출 (시작/마감 구분)
  void updateSelectedDate(DateTime date, bool isStart) {
    final current = isStart ? state.startDateTime : state.endDateTime;
    final updated =
        DateTime(date.year, date.month, date.day, current.hour, current.minute);

    if (_isBeforeToday(updated)) return; // 과거일 선택 불가
    if (isStart && updated.isAfter(maxStartDate)) return; // 시작일은 3개월 이내만 가능

    if (isStart) {
      // 시작일이 바뀌면 마감일 유효성도 함께 고려
      final minEnd = minEndDateFrom(updated);
      final maxEnd = maxEndDateFrom(updated);
      final currentEnd = state.endDateTime;

      final adjustedEnd =
          (currentEnd.isBefore(minEnd) || currentEnd.isAfter(maxEnd))
              ? minEnd
              : currentEnd;

      state = state.copyWith(
        startDateTime: updated,
        endDateTime: adjustedEnd,
      );
    } else {
      // 마감일 범위 검사
      final minEnd = minEndDateFrom(state.startDateTime);
      final maxEnd = maxEndDateFrom(state.startDateTime);

      if (updated.isBefore(minEnd) || updated.isAfter(maxEnd)) return;

      state = state.copyWith(endDateTime: updated);
    }
  }

  // 시간 선택 시 호출 (시작/마감 구분)
  void updateSelectedTime(int hour, int minute, bool isStart) {
    final base = isStart ? state.startDateTime : state.endDateTime;
    final updated = DateTime(base.year, base.month, base.day, hour, minute);

    final now = DateTime.now();
    final nowTruncated =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);

    // 시작 시간이 오늘인데 현재 시간보다 이전이면 무시
    if (_isSameDay(updated, now) && updated.isBefore(nowTruncated)) return;

    if (isStart) {
      final minEnd = minEndDateFrom(updated);
      final maxEnd = maxEndDateFrom(updated);
      final currentEnd = state.endDateTime;

      final adjustedEnd =
          (currentEnd.isBefore(minEnd) || currentEnd.isAfter(maxEnd))
              ? minEnd
              : currentEnd;

      state = state.copyWith(
        startDateTime: updated,
        endDateTime: adjustedEnd,
        startTimePicked: true,
      );
    } else {
      final minEnd = minEndDateFrom(state.startDateTime);
      final maxEnd = maxEndDateFrom(state.startDateTime);

      if (updated.isBefore(minEnd) || updated.isAfter(maxEnd)) return;

      state = state.copyWith(
        endDateTime: updated,
        endTimePicked: true,
      );
    }
  }

  // 시작 시간 확정
  void confirmStartTime() {
    state = state.copyWith(startTimePicked: true);
  }

  // 마감 시간 확정
  void confirmEndTime() {
    state = state.copyWith(endTimePicked: true);
  }

  // 오늘 이전 날짜인지 여부 확인
  bool _isBeforeToday(DateTime dt) {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    return dt.isBefore(todayStart);
  }

  // 같은 날인지 확인
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // 모집 시작일 최대: 오늘 기준 3개월 뒤
  static DateTime get maxStartDate => _addMonths(DateTime.now(), 3);

  // 마감일 최소: 시작일 + 1일
  static DateTime minEndDateFrom(DateTime start) =>
      start.add(const Duration(days: 1));

  // 마감일 최대: 시작일 + 27일 (총 28일 범위)
  static DateTime maxEndDateFrom(DateTime start) =>
      start.add(const Duration(days: 27));

  // 기준 날짜로부터 정확히 N개월 뒤 계산
  static DateTime _addMonths(DateTime base, int months) {
    final year = base.year + ((base.month + months - 1) ~/ 12);
    final month = (base.month + months - 1) % 12 + 1;
    final day = base.day;

    final lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, day > lastDay ? lastDay : day);
  }
}
