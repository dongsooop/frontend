import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';

class CheckLocalTimetableUseCase {
  final TimetableRepository _timetableRepository;

  CheckLocalTimetableUseCase(this._timetableRepository,);

  Future<bool> execute(int year, Semester semester) async {
    return await _timetableRepository.checkLocalTimetable(year, semester);
  }
}