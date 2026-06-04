import 'package:dongsoop/domain/timetable/model/local_timetable_info.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';

class GetTimetableInfoUseCase {
  final TimetableRepository _timetableRepository;

  GetTimetableInfoUseCase(this._timetableRepository,);

  Future<List<LocalTimetableInfo>> execute() async {
    return await _timetableRepository.getTimetableList();
  }
}