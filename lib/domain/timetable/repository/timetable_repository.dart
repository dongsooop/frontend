import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/timetable.dart';
import 'package:dongsoop/domain/timetable/model/timetable_AI.dart';
import 'package:dongsoop/domain/timetable/model/timetable_request.dart';

abstract class TimetableRepository {
  Future<List<Timetable>> getTimetable(int year, Semester semester);
  Future<bool> createTimetable(TimetableRequest request);
  Future<bool> updateTimetable(Timetable timetable);
  Future<bool> deleteTimetable(int id);
  // AI
  Future<TimetableAi> timetableAnalysis();
}