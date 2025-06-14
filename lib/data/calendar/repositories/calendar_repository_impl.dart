import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/calendar/data_sources/calendar_data_source.dart';
import 'package:dongsoop/data/calendar/models/calendar_list_model.dart';
import 'package:dongsoop/domain/calendar/entities/calendar_entity.dart';
import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';
import 'package:dongsoop/domain/calendar/repository/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarDataSource _dataSource;

  CalendarRepositoryImpl(this._dataSource);

  @override
  Future<List<CalendarListEntity>> fetchCalendarList({
    required int memberId,
    required DateTime currentMonth,
  }) async {
    return _handle(() async {
      final models = await _dataSource.fetchCalendarList(
        memberId: memberId,
        currentMonth: currentMonth,
      );
      return models.map((model) => model.toEntity()).toList();
    }, CalendarException());
  }

  @override
  Future<void> submitCalendar({
    required CalendarEntity entity,
  }) async {
    return _handle(() async {
      await _dataSource.submitCalendar(entity: entity);
    }, CalendarSubmitException());
  }

  @override
  Future<void> updateCalendar({
    required CalendarEntity entity,
  }) async {
    return _handle(() async {
      await _dataSource.updateCalendar(entity: entity);
    }, CalendarUpdateException());
  }

  @override
  Future<void> deleteCalendar({
    required int calendarId,
  }) async {
    return _handle(() async {
      await _dataSource.deleteCalendar(calendarId: calendarId);
    }, CalendarDeleteException());
  }

  Future<T> _handle<T>(Future<T> Function() action, Exception exception) async {
    try {
      return await action();
    } catch (_) {
      throw exception;
    }
  }
}
