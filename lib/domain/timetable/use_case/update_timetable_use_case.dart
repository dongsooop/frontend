import 'package:dongsoop/domain/timetable/model/timetable.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';

class UpdateTimetableUseCase {
  final TimetableRepository _timetableRepository;

  UpdateTimetableUseCase(this._timetableRepository,);

  Future<bool> execute(Timetable timetable) async {
    return await _timetableRepository.updateTimetable(timetable);
  }
}