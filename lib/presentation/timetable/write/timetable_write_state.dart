import 'package:dongsoop/domain/timetable/enum/semester.dart';

class TimetableWriteState {
  final bool isLoading;
  final String? errorMessage;
  final int? year;
  final Semester? semester;

  TimetableWriteState({
    required this.isLoading,
    this.errorMessage,
    this.year,
    this.semester,
  });

  TimetableWriteState copyWith({
    bool? isLoading,
    String? errorMessage,
    int? year,
    Semester? semester,
  }) {
    return TimetableWriteState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      year: year ?? this.year,
      semester: semester ?? this.semester,
    );
  }
}