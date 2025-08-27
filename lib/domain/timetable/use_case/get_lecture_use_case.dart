import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';

class GetLectureUseCase {
  final TimetableRepository _timetableRepository;

  GetLectureUseCase(this._timetableRepository,);

  Future<List<Lecture>?> execute(int year, Semester semester) async {
    return await _timetableRepository.getLecture(year, semester);
  }
}