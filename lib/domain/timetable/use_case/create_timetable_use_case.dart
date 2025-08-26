import 'package:dongsoop/domain/timetable/model/timetable_request.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';

class CreateTimetableUseCase {
  final TimetableRepository _timetableRepository;

  CreateTimetableUseCase(this._timetableRepository,);

  Future<bool> execute(TimetableRequest request) async {
    return await _timetableRepository.createTimetable(request);
  }
}