import 'package:dongsoop/core/network/error_handler_mixin.dart';
import 'package:dongsoop/data/timetable/data_source/timetable_data_source.dart';
import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/domain/timetable/model/lecture_AI.dart';
import 'package:dongsoop/domain/timetable/model/lecture_request.dart';
import 'package:dongsoop/domain/timetable/model/local_timetable_info.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';
import 'package:image_picker/image_picker.dart';

class TimetableRepositoryImpl with ErrorHandlerMixin implements TimetableRepository {
  final TimetableDataSource _timetableDataSource;

  TimetableRepositoryImpl(
    this._timetableDataSource,
  );

  @override
  Future<bool> createLecture(LectureRequest request) async {
    try {
      return await _timetableDataSource.createLecture(request);
    } catch (e) {
      throw convertError(e);
    }
  }

  @override
  Future<bool> deleteLecture(int id) async {
    try {
      return await _timetableDataSource.deleteLecture(id);
    } catch (e) {
      throw convertError(e);
    }
  }

  @override
  Future<List<Lecture>?> getLecture(int year, Semester semester) async {
    try {
      return await _timetableDataSource.getLecture(year, semester);
    } catch (e) {
      throw convertError(e);
    }
  }

  @override
  Future<bool> updateLecture(Lecture timetable) async {
    try {
      return await _timetableDataSource.updateLecture(timetable);
    } catch (e) {
      throw convertError(e);
    }
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
    try {
      await _timetableDataSource.deleteTimetable(year, semester);
    } catch (e) {
      throw convertError(e);
    }
  }

  @override
  Future<List<LectureAi>> getTimetableAnalysis(XFile file) async {
    try {
      return await _timetableDataSource.timetableAnalysis(file);
    } catch (e) {
      throw convertError(e);
    }
  }

  @override
  Future<void> saveMultipleTimetable(List<LectureRequest> timetable) async {
    try {
      await _timetableDataSource.saveMultipleTimetable(timetable);
    } catch (e) {
      throw convertError(e);
    }
  }
}