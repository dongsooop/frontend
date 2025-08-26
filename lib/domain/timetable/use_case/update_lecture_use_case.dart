import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';

class UpdateLectureUseCase {
  final TimetableRepository _timetableRepository;

  UpdateLectureUseCase(this._timetableRepository,);

  Future<bool> execute(Lecture timetable) async {
    return await _timetableRepository.updateLecture(timetable);
  }
}