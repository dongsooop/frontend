import 'package:dongsoop/data/timetable/data_source/timetable_data_source.dart';
import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/domain/timetable/model/lecture_AI.dart';
import 'package:dongsoop/domain/timetable/model/lecture_request.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';

class TimetableRepositoryImpl implements TimetableRepository {
  final TimetableDataSource _timetableDataSource;

  TimetableRepositoryImpl(
    this._timetableDataSource,
  );

  @override
  Future<bool> createLecture(LectureRequest request) {
    return _timetableDataSource.createLecture(request);
  }

  @override
  Future<bool> deleteLecture(int id) {
    return _timetableDataSource.deleteLecture(id);
  }

  @override
  Future<List<Lecture>> getLecture(int year, Semester semester) {
    return _timetableDataSource.getLecture(year, semester);
  }

  @override
  Future<LectureAi> timetableAnalysis() {
    return _timetableDataSource.timetableAnalysis();
  }

  @override
  Future<bool> updateLecture(Lecture timetable) {
    return _timetableDataSource.updateLecture(timetable);
  }
}