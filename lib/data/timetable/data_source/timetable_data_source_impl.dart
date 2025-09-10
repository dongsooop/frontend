import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/core/storage/hive_service.dart';
import 'package:dongsoop/data/timetable/data_source/timetable_data_source.dart';
import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/lecture.dart';
import 'package:dongsoop/domain/timetable/model/lecture_AI.dart';
import 'package:dongsoop/domain/timetable/model/lecture_request.dart';
import 'package:dongsoop/domain/timetable/model/local_timetable_info.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class TimetableDataSourceImpl implements TimetableDataSource {
  final Dio _authDio;
  final Dio _aiDio;
  final HiveService _hiveService;

  TimetableDataSourceImpl(
    this._authDio,
    this._aiDio,
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

    print('request: ${request.toJson()}');
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
  Future<List<LectureAi>> timetableAnalysis(XFile file) async {
    final endpoint = dotenv.get('TIMETABLE_ANALYSIS_ENDPOINT');

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
      });
      final response = await _authDio.post(
        endpoint,
        data: formData,
      );

      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((e) => LectureAi.fromJson(e as Map<String, dynamic>)).toList();
      }
      throw TimetableAnalysisFailedException();
    } catch (e) {
      throw TimetableAnalysisFailedException();
    }
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

  @override
  Future<List<LocalTimetableInfo>> getTimetableList() async {
    return await _hiveService.getAllTimetableInfos();
  }

  @override
  Future<void> deleteTimetable(int year, Semester semester) async {
    final endpoint = dotenv.get('TIMETABLE_ENDPOINT');
    final pathParam = '$endpoint/$year/${semester.name}';

    try {
      final response = await _authDio.delete(pathParam);

      if (response.statusCode == HttpStatusCode.noContent.code) {
        await _hiveService.deleteTimetableInfo(year, semester);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveMultipleTimetable(List<LectureRequest> timetable) async {
    final endpoint = dotenv.get('TIMETABLE_MULTIPLE_ENDPOINT');
    final requestBody = timetable.map((e) => e.toJson()).toList();

    print('timetable: $requestBody');

    try {
      final response = await _authDio.post(endpoint, data: requestBody);
      if (response.statusCode == HttpStatusCode.created.code) {
        return; // 성공
      }
      if (response.statusCode == HttpStatusCode.multiStatus.code) {
        // 부분 성공
        final failed = (response.data as List)
            .map((e) => e is Map<String, dynamic> ? e['name'] as String? : null)
            .whereType<String>()
            .toList();
        final prefix = failed.isEmpty ? '일부 강의' : failed.join(', ');
        throw TimetableMultiStatusException('$prefix 강의 저장에 실패했어요');
      }
      throw TimetableException();
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.conflict.code) {
        throw TimetableConflictException();
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}