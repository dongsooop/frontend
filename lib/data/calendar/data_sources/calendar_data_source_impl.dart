import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/calendar/data_sources/calendar_data_source.dart';
import 'package:dongsoop/data/calendar/models/calendar_list_model.dart';
import 'package:dongsoop/data/calendar/models/calendar_model.dart';
import 'package:dongsoop/domain/calendar/entities/calendar_entity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CalendarDataSourceImpl implements CalendarDataSource {
  final Dio _authDio;
  final Dio _plainDio;

  CalendarDataSourceImpl(this._authDio, this._plainDio);

  @override
  Future<List<CalendarListModel>> fetchCalendarList({
    required DateTime currentMonth,
  }) async {
    final base = dotenv.get('CALENDAR_ENDPOINT');
    final yearMonth =
        '${currentMonth.year}-${currentMonth.month.toString().padLeft(2, '0')}';
    final url = '$base/$yearMonth';

    print('[fetchCalendarList] GET $url');

    final response = await _authDio.get(url);

    print('[fetchCalendarList] status: ${response.statusCode}, data: ${response.data}');

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
  Future<List<CalendarListModel>> fetchGuestCalendar({
    required DateTime currentMonth,
  }) async {
    final base = dotenv.get('CALENDAR_ENDPOINT');
    final yearMonth =
        '${currentMonth.year}-${currentMonth.month.toString().padLeft(2, '0')}';
    final url = '$base/$yearMonth';

    print('[fetchGuestCalendar] GET $url');

    final response = await _plainDio.get(url);

    print('[fetchGuestCalendar] status: ${response.statusCode}, data: ${response.data}');

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
    final url = dotenv.get('CALENDAR_WRITE_ENDPOINT');
    final model = CalendarModel.fromEntity(entity);

    print('[submitCalendar] POST $url');
    print('[submitCalendar] body: ${model.toJson()}');

    final response = await _authDio.post(url, data: model.toJson());

    print('[submitCalendar] status: ${response.statusCode}, data: ${response.data}');

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

    final url = '${dotenv.get('CALENDAR_WRITE_ENDPOINT')}/$calendarId';
    final model = CalendarModel.fromEntity(entity);

    print('[updateCalendar] PATCH $url');
    print('[updateCalendar] body: ${model.toJson()}');

    final response = await _authDio.patch(url, data: model.toJson());

    print('[updateCalendar] status: ${response.statusCode}, data: ${response.data}');

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteCalendar({
    required int calendarId,
  }) async {
    final url = '${dotenv.get('CALENDAR_WRITE_ENDPOINT')}/$calendarId';

    print('[deleteCalendar] DELETE $url');

    final response = await _authDio.delete(url);

    print('[deleteCalendar] status: ${response.statusCode}, data: ${response.data}');

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }
}
