import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';

class DeleteLectureUseCase {
  final TimetableRepository _timetableRepository;

  DeleteLectureUseCase(this._timetableRepository,);

  Future<bool> execute(int id) async {
    return await _timetableRepository.deleteLecture(id);
  }
}