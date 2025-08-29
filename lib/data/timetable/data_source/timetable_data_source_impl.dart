import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/core/storage/hive_service.dart';
import 'package:dongsoop/data/timetable/data_source/timetable_data_source.dart';
import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/domain/timetable/model/lecture_AI.dart';
import 'package:dongsoop/domain/timetable/model/lecture_request.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TimetableDataSourceImpl implements TimetableDataSource {
  final Dio _authDio;
  final HiveService _hiveService;

  TimetableDataSourceImpl(
    this._authDio,
    this._hiveService,
  );

  @override
  Future<List<Lecture>?> getLecture(int year, Semester semester) async {
    final endpoint = dotenv.get('TIMETABLE_ENDPOINT');
    final pathParam = '$endpoint/$year/${semester.name}';

    try {
      final response = await _authDio.get(pathParam);

      if (response.statusCode == HttpStatusCode.ok.code) {
        if (response.data == null) return null;
        final List<dynamic> data = response.data;

        final List<Lecture>? timetable = data
            .map((e) => Lecture.fromJson(e as Map<String, dynamic>))
            .toList();

        return timetable;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> createLecture(LectureRequest request) async {
    final endpoint = dotenv.get('TIMETABLE_ENDPOINT');

    try {
      final response = await _authDio.post(endpoint, data: request.toJson());
      if (response.statusCode == HttpStatusCode.created.code) {
        return true;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateLecture(Lecture timetable) async {
    final endpoint = dotenv.get('TIMETABLE_ENDPOINT');

    try {
      final response = await _authDio.patch(endpoint, data: timetable.toJson());

      if (response.statusCode == HttpStatusCode.noContent.code) {
        return true;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteLecture(int id) async {
    final endpoint = dotenv.get('TIMETABLE_ENDPOINT');
    final pathParam = '$endpoint/$id';

    try {
      final response = await _authDio.delete(pathParam);

      if (response.statusCode == HttpStatusCode.noContent.code) {
        return true;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LectureAi> timetableAnalysis() async {
    throw UnimplementedError();
  }

  @override
  Future<bool> createTimetable(int year, Semester semester) async {
    try {
      final exists = await _hiveService.hasLocalTimetable(year, semester);
      if (exists) {
        return false;
      }

      await _hiveService.saveTimetableInfo(year, semester);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> hasLocalTimetable(int year, Semester semester) async {
    return await _hiveService.hasLocalTimetable(year, semester);
  }
}