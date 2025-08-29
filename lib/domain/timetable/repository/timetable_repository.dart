import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/domain/timetable/model/lecture_AI.dart';
import 'package:dongsoop/domain/timetable/model/lecture_request.dart';

abstract class TimetableRepository {
  Future<bool> createTimetable(int year, Semester semester);
  Future<bool> checkLocalTimetable(int year, Semester semester);
  Future<List<Lecture>?> getLecture(int year, Semester semester);
  Future<bool> createLecture(LectureRequest request);
  Future<bool> updateLecture(Lecture timetable);
  Future<bool> deleteLecture(int id);
  // AI
  Future<LectureAi> timetableAnalysis();
}