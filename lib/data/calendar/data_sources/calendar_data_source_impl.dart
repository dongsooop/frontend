import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/calendar/data_sources/calendar_data_source.dart';
import 'package:dongsoop/data/calendar/models/calendar_list_model.dart';
import 'package:dongsoop/data/calendar/models/calendar_model.dart';
import 'package:dongsoop/domain/calendar/entities/calendar_entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CalendarDataSourceImpl implements CalendarDataSource {
  final Dio _authDio;

  CalendarDataSourceImpl(this._authDio);

  @override
  Future<List<CalendarListModel>> fetchCalendarList({
    required int memberId,
    required DateTime currentMonth,
  }) async {
    final calendarBase = dotenv.get('CALENDAR_ENDPOINT');
    // 'yyyy-MM' 형식으로 직접 포맷
    final yearMonth =
        '${currentMonth.year}-${currentMonth.month.toString().padLeft(2, '0')}';
    final url = '$calendarBase/$memberId/year-month/$yearMonth';
    final response = await _authDio.get(url);

    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! List) {
        throw FormatException('응답 데이터 형식이 List가 아닙니다.');
      }
      return data.map((e) => CalendarListModel.fromJson(e)).toList();
    }

    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<void> submitCalendar({
    required CalendarEntity entity,
  }) async {
    final url = dotenv.get('CALENDAR_ENDPOINT');
    final model = CalendarModel.fromEntity(entity);
    final response = await _authDio.post(url, data: model.toJson());

    if (response.statusCode != HttpStatusCode.created.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }

  @override
  Future<void> updateCalendar({
    required CalendarEntity entity,
  }) async {
    final calendarId = entity.id;
    if (calendarId == null) {
      throw Exception('calendarId is null');
    }

    final url = '${dotenv.get('CALENDAR_ENDPOINT')}/$calendarId';
    final model = CalendarModel.fromEntity(entity);
    final response = await _authDio.patch(url, data: model.toJson());

    if (response.statusCode != HttpStatusCode.ok.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteCalendar({
    required int calendarId,
  }) async {
    final url = '${dotenv.get('CALENDAR_ENDPOINT')}/$calendarId';
    final response = await _authDio.delete(url);

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }
}
