import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/domain/timetable/model/lecture_AI.dart';
import 'package:dongsoop/domain/timetable/model/lecture_request.dart';
import 'package:dongsoop/domain/timetable/model/local_timetable_info.dart';
import 'package:image_picker/image_picker.dart';

abstract class TimetableDataSource {
  Future<bool> createTimetable(int year, Semester semester);
  Future<bool> hasLocalTimetable(int year, Semester semester);
  Future<List<Lecture>?> getLecture(int year, Semester semester);
  Future<List<LocalTimetableInfo>> getTimetableList();
  Future<void> deleteTimetable(int year, Semester semester);
  Future<bool> createLecture(LectureRequest request);
  Future<bool> updateLecture(Lecture timetable);
  Future<bool> deleteLecture(int id);
  // AI
  Future<List<LectureAi>> timetableAnalysis(XFile file);
  Future<void> saveMultipleTimetable(List<LectureRequest> timetable);
}