import 'package:dongsoop/data/timetable/data_source/timetable_data_source.dart';
import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/timetable.dart';
import 'package:dongsoop/domain/timetable/model/timetable_AI.dart';
import 'package:dongsoop/domain/timetable/model/timetable_request.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';

class TimetableRepositoryImpl implements TimetableRepository {
  final TimetableDataSource _timetableDataSource;

  TimetableRepositoryImpl(
    this._timetableDataSource,
  );

  @override
  Future<bool> createTimetable(TimetableRequest request) {
    return _timetableDataSource.createTimetable(request);
  }

  @override
  Future<bool> deleteTimetable(int id) {
    return _timetableDataSource.deleteTimetable(id);
  }

  @override
  Future<List<Timetable>> getTimetable(int year, Semester semester) {
    return _timetableDataSource.getTimetable(year, semester);
  }

  @override
  Future<TimetableAi> timetableAnalysis() {
    return _timetableDataSource.timetableAnalysis();
  }

  @override
  Future<bool> updateTimetable(Timetable timetable) {
    return _timetableDataSource.updateTimetable(timetable);
  }
}