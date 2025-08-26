import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';

class GetTimetableUseCase {
  final TimetableRepository _timetableRepository;

  GetTimetableUseCase(this._timetableRepository,);

  Future<List<Lecture>?> execute(int year, int month) async {
    Semester semester;
    if (month >= 2 && month <= 6) {
      semester = Semester.FIRST;
    } else if (month >= 8 && month <= 12) {
      semester = Semester.SECOND;
    } else if (month == 7){
      semester = Semester.SUMMER;
    } else if (month == 1){
      semester = Semester.WINTER;
    } else {
      throw Exception('알 수 없는 오류가 발생했습니다.');
    }

    return await _timetableRepository.getLecture(year, semester);
  }
}