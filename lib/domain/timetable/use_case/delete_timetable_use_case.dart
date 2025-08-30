import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';

class DeleteTimetableUseCase {
  final TimetableRepository _timetableRepository;

  DeleteTimetableUseCase(this._timetableRepository,);

  Future<void> execute(int year, Semester semester) async {
    return await _timetableRepository.deleteTimetable(year, semester);
  }
}