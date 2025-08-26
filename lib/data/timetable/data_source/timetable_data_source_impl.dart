import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/timetable/data_source/timetable_data_source.dart';
import 'package:dongsoop/domain/timetable/enum/semester.dart';
import 'package:dongsoop/domain/timetable/model/timetable.dart';
import 'package:dongsoop/domain/timetable/model/timetable_AI.dart';
import 'package:dongsoop/domain/timetable/model/timetable_request.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TimetableDataSourceImpl implements TimetableDataSource {
  final Dio _authDio;

  TimetableDataSourceImpl(
    this._authDio,
  );

  @override
  Future<List<Timetable>> getTimetable(int year, Semester semester) async {
    final endpoint = dotenv.get('TIMETABLE_ENDPOINT');

    try {
      final response = await _authDio.get(endpoint);

      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data;

        final List<Timetable> timetable = data
            .map((e) => Timetable.fromJson(e as Map<String, dynamic>))
            .toList();

        return timetable;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> createTimetable(TimetableRequest request) async {
    final endpoint = dotenv.get('TIMETABLE_ENDPOINT');

    try {
      final response = await _authDio.post(endpoint, data: request.toJson());
      if (response.statusCode == HttpStatusCode.noContent.code) {
        return true;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateTimetable(Timetable timetable) async {
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
  Future<bool> deleteTimetable(int id) async {
    final endpoint = dotenv.get('TIMETABLE_ENDPOINT');

    try {
      final response = await _authDio.get(endpoint);

      if (response.statusCode == HttpStatusCode.noContent.code) {
        return true;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TimetableAi> timetableAnalysis() async {
    throw UnimplementedError();
  }
}