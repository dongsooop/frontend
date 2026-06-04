import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';

class CreateTimetableUseCase {
  final TimetableRepository _timetableRepository;

  CreateTimetableUseCase(this._timetableRepository,);

  Future<bool> execute(int year, Semester semester) async {
    return await _timetableRepository.createTimetable(year, semester);
  }
}