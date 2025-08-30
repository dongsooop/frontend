import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';

class TimetableState {
  final bool isLoading;
  final String? errorMessage;
  final int? year;
  final Semester? semester;
  final List<Lecture>? lectureList;
  final bool? exists;

  TimetableState({
    required this.isLoading,
    this.errorMessage,
    this.year,
    this.semester,
    this.lectureList,
    this.exists,
  });

  TimetableState copyWith({
    bool? isLoading,
    String? errorMessage,
    int? year,
    Semester? semester,
    List<Lecture>? lectureList,
    bool? exists,
  }) {
    return TimetableState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      year: year ?? this.year,
      semester: semester ?? this.semester,
      lectureList: lectureList ?? this.lectureList,
      exists: exists ?? this.exists,
    );
  }
}