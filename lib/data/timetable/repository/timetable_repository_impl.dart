import 'package:dongsoop/data/timetable/data_source/timetable_data_source.dart';
import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/domain/timetable/model/lecture_AI.dart';
import 'package:dongsoop/domain/timetable/model/lecture_request.dart';
import 'package:dongsoop/domain/timetable/model/local_timetable_info.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';
import 'package:image_picker/image_picker.dart';

class TimetableRepositoryImpl implements TimetableRepository {
  final TimetableDataSource _timetableDataSource;

  TimetableRepositoryImpl(
    this._timetableDataSource,
  );

  @override
  Future<bool> createLecture(LectureRequest request) async {
    return await _timetableDataSource.createLecture(request);
  }

  @override
  Future<bool> deleteLecture(int id) async {
    return await _timetableDataSource.deleteLecture(id);
  }

  @override
  Future<List<Lecture>?> getLecture(int year, Semester semester) async {
    return await _timetableDataSource.getLecture(year, semester);
  }

  @override
  Future<bool> updateLecture(Lecture timetable) async {
    return await _timetableDataSource.updateLecture(timetable);
  }

  @override
  Future<bool> createTimetable(int year, Semester semester) async {
    return await _timetableDataSource.createTimetable(year, semester);
  }

  @override
  Future<bool> checkLocalTimetable(int year, Semester semester) async {
    return await _timetableDataSource.hasLocalTimetable(year, semester);
  }

  @override
  Future<List<LocalTimetableInfo>> getTimetableList() async {
    return await _timetableDataSource.getTimetableList();
  }

  @override
  Future<void> deleteTimetable(int year, Semester semester) async {
    await _timetableDataSource.deleteTimetable(year, semester);
  }

  @override
  Future<List<LectureAi>> getTimetableAnalysis(XFile file) async {
    return await _timetableDataSource.timetableAnalysis(file);
  }
}