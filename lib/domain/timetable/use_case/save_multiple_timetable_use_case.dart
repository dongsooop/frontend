import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/lecture_AI.dart';
import 'package:dongsoop/domain/timetable/model/lecture_request.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';

class SaveMultipleTimetableUseCase {
  final TimetableRepository _timetableRepository;

  SaveMultipleTimetableUseCase(this._timetableRepository,);

  Future<void> execute(int year, Semester semester, List<LectureAi> timetable) async {
    final requests = timetable
        .map((e) => e.toRequest(year: year, semester: semester))
        .toList();

    await _timetableRepository.saveMultipleTimetable(requests);
  }
}

extension LectureAiMapper on LectureAi {
  LectureRequest toRequest({
    required int year,
    required Semester semester,
  }) {
    return LectureRequest(
      name: name,
      professor: professor,
      location: location,
      week: week,
      startAt: startAt,
      endAt: endAt,
      year: year,
      semester: semester.name,
    );
  }
}