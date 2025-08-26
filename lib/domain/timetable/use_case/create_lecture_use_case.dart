import 'package:dongsoop/domain/timetable/model/lecture_request.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';

class CreateLectureUseCase {
  final TimetableRepository _timetableRepository;

  CreateLectureUseCase(this._timetableRepository,);

  Future<bool> execute(LectureRequest request) async {
    return await _timetableRepository.createLecture(request);
  }
}