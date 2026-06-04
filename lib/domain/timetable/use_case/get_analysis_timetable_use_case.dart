import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';
import 'package:image_picker/image_picker.dart';

class GetAnalysisTimetableUseCase {
  final TimetableRepository _timetableRepository;

  GetAnalysisTimetableUseCase(this._timetableRepository,);

  Future<bool> execute(XFile file) async {
    return await _timetableRepository.getTimetableAnalysis(file);
  }
}