import 'package:dongsoop/domain/timetable/model/local_timetable_info.dart';

class TimetableListState {
  final bool isLoading;
  final String? errorMessage;
  final List<LocalTimetableInfo> localTimetableInfo;

  TimetableListState({
    required this.isLoading,
    this.errorMessage,
    required this.localTimetableInfo,
  });

  TimetableListState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<LocalTimetableInfo>? localTimetableInfo,
  }) {
    return TimetableListState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      localTimetableInfo: localTimetableInfo ?? this.localTimetableInfo,
    );
  }
}