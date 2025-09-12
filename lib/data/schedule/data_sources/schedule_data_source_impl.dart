import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/schedule/data_sources/schedule_data_source.dart';
import 'package:dongsoop/data/schedule/models/schedule_list_model.dart';
import 'package:dongsoop/data/schedule/models/schedule_model.dart';
import 'package:dongsoop/domain/schedule/entities/schedule_entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ScheduleDataSourceImpl implements ScheduleDataSource {
  final Dio _authDio;
  final Dio _plainDio;

  ScheduleDataSourceImpl(this._authDio, this._plainDio);

  @override
  Future<List<ScheduleListModel>> fetchScheduleList({
    required DateTime currentMonth,
  }) async {
    final base = dotenv.get('CALENDAR_ENDPOINT');
    final yearMonth = '${currentMonth.year}-${currentMonth.month.toString().padLeft(2, '0')}';
    final url = '$base/$yearMonth';

    final response = await _authDio.get(url);

    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! List) {
        throw FormatException('응답 데이터 형식이 List가 아닙니다.');
      }
      return data.map((e) => ScheduleListModel.fromJson(e)).toList();
    }

    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<List<ScheduleListModel>> fetchGuestSchedule({
    required DateTime currentMonth,
  }) async {
    final base = dotenv.get('CALENDAR_ENDPOINT');
    final yearMonth = '${currentMonth.year}-${currentMonth.month.toString().padLeft(2, '0')}';
    final url = '$base/$yearMonth';

    final response = await _plainDio.get(url);

    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! List) {
        throw FormatException('응답 데이터 형식이 List가 아닙니다.');
      }
      return data.map((e) => ScheduleListModel.fromJson(e)).toList();
    }

    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<void> submitSchedule({
    required ScheduleEntity entity,
  }) async {
    final url = dotenv.get('CALENDAR_WRITE_ENDPOINT');
    final model = ScheduleModel.fromEntity(entity);

    final response = await _authDio.post(url, data: model.toJson());

    if (response.statusCode != HttpStatusCode.created.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }

  @override
  Future<void> updateSchedule({
    required ScheduleEntity entity,
  }) async {
    final calendarId = entity.id;
    if (calendarId == null) {
      throw Exception('calendarId is null');
    }

    final url = '${dotenv.get('CALENDAR_WRITE_ENDPOINT')}/$calendarId';
    final model = ScheduleModel.fromEntity(entity);

    final response = await _authDio.patch(url, data: model.toJson());

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteSchedule({
    required int calendarId,
  }) async {
    final url = '${dotenv.get('CALENDAR_WRITE_ENDPOINT')}/$calendarId';

    final response = await _authDio.delete(url);

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }
}