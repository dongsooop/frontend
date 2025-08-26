import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';

class DeleteTimetableUseCase {
  final TimetableRepository _timetableRepository;

  DeleteTimetableUseCase(this._timetableRepository,);

  Future<bool> execute(int id) async {
    return await _timetableRepository.deleteLecture(id);
  }
}