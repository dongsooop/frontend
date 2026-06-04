import 'package:dongsoop/domain/timetable/enum/week_day.dart';

class LectureWriteState {
  final bool isLoading;
  final String? errorMessage;
  final WeekDay day;
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;
  final bool isEnabled;

  LectureWriteState({
    required this.isLoading,
    this.errorMessage,
    required this.day,
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.isEnabled,
  });

  LectureWriteState copyWith({
    bool? isLoading,
    String? errorMessage,
    WeekDay? day,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    bool? isEnabled,
  }) {
    return LectureWriteState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      day: day ?? this.day,
      startHour: startHour ?? this.startHour,
      startMinute: startMinute ?? this.startMinute,
      endHour: endHour ?? this.endHour,
      endMinute: endMinute ?? this.endMinute,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}