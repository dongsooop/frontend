import 'package:flutter_riverpod/flutter_riverpod.dart';

// 상태를 담는 클래스
class DateTimeSelectorState {
  final DateTime startDateTime;
  final DateTime endDateTime;
  final bool startTimePicked;
  final bool endTimePicked;

  DateTimeSelectorState({
    required this.startDateTime,
    required this.endDateTime,
    required this.startTimePicked,
    required this.endTimePicked,
  });

  // 상태 복사(변경된 값만 업데이트)
  DateTimeSelectorState copyWith({
    DateTime? startDateTime,
    DateTime? endDateTime,
    bool? startTimePicked,
    bool? endTimePicked,
  }) {
    return DateTimeSelectorState(
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      startTimePicked: startTimePicked ?? this.startTimePicked,
      endTimePicked: endTimePicked ?? this.endTimePicked,
    );
  }
}

// 상태 관리하는 ViewModel(StateNotifier 기반)
class DateTimeSelectorViewModel extends StateNotifier<DateTimeSelectorState> {
  DateTimeSelectorViewModel()
      : super(
          DateTimeSelectorState(
            startDateTime: roundUpTo10(DateTime.now()),
            endDateTime:
                roundUpTo10(DateTime.now()).add(const Duration(days: 1)),
            startTimePicked: false,
            endTimePicked: false,
          ),
        );

  static DateTime roundUpTo10(DateTime dt) {
    final minute = dt.minute;
    final roundedMinute = ((minute + 9) ~/ 10) * 10;
    if (roundedMinute == 60) {
      dt = dt.add(const Duration(hours: 1));
      return DateTime(dt.year, dt.month, dt.day, dt.hour, 0);
    }
    return DateTime(dt.year, dt.month, dt.day, dt.hour, roundedMinute);
  }

  // 시작일 가능한 최대값: 오늘 + 3개월(28x3) -1 -> 총 84일
  static DateTime get maxStartDate =>
      DateTime.now().add(const Duration(days: 83));

  // 종료일 가능한 최대값: 시작일 + 27일 -> 총 28일
  static DateTime maxEndDateFrom(DateTime start) =>
      start.add(const Duration(days: 27));

  // 종료일 가능한 최소값: 시작일 + 1일
  static DateTime minEndDateFrom(DateTime start) =>
      start.add(const Duration(days: 1));

  void updateStartDate(DateTime date) {
    final newStart = DateTime(
      date.year,
      date.month,
      date.day,
      state.startDateTime.hour,
      state.startDateTime.minute,
    );

    // 3개월 제한
    if (newStart.isAfter(maxStartDate)) return;

    // 종료일 자동 조정 (최소 하루 후, 최대 28일 후)
    final minEnd = minEndDateFrom(newStart);
    final maxEnd = maxEndDateFrom(newStart);
    final currentEnd = state.endDateTime;

    final adjustedEnd =
        currentEnd.isBefore(minEnd) || currentEnd.isAfter(maxEnd)
            ? minEnd
            : currentEnd;

    state = state.copyWith(startDateTime: newStart, endDateTime: adjustedEnd);
  }

  void updateEndDate(DateTime date) {
    final newEnd = DateTime(
      date.year,
      date.month,
      date.day,
      state.startDateTime.hour,
      state.startDateTime.minute,
    );

    final minEnd = minEndDateFrom(state.startDateTime);
    final maxEnd = maxEndDateFrom(state.startDateTime);

    if (newEnd.isBefore(minEnd) || newEnd.isAfter(maxEnd)) return;

    state = state.copyWith(endDateTime: newEnd);
  }

  void updateStartTime(DateTime time) {
    final newStart = DateTime(
      state.startDateTime.year,
      state.startDateTime.month,
      state.startDateTime.day,
      time.hour,
      time.minute,
    );

    final minEnd = minEndDateFrom(newStart);
    final maxEnd = maxEndDateFrom(newStart);
    final currentEnd = state.endDateTime;

    final adjustedEnd =
        currentEnd.isBefore(minEnd) || currentEnd.isAfter(maxEnd)
            ? minEnd
            : currentEnd;

    state = state.copyWith(
      startDateTime: newStart,
      endDateTime: adjustedEnd,
      startTimePicked: true,
      endTimePicked:
          adjustedEnd != state.endDateTime ? true : state.endTimePicked,
    );
  }

  void updateEndTime(DateTime time) {
    final newEnd = DateTime(
      state.endDateTime.year,
      state.endDateTime.month,
      state.endDateTime.day,
      time.hour,
      time.minute,
    );

    if (newEnd.isBefore(state.startDateTime) ||
        newEnd.difference(state.startDateTime).inDays < 1 ||
        newEnd.difference(state.startDateTime).inDays > 28) return;

    state = state.copyWith(endDateTime: newEnd, endTimePicked: true);
  }
}
