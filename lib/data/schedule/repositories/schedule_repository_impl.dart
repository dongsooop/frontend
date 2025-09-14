import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/schedule/data_sources/schedule_data_source.dart';
import 'package:dongsoop/data/schedule/models/schedule_list_model.dart';
import 'package:dongsoop/domain/schedule/entities/schedule_entity.dart';
import 'package:dongsoop/domain/schedule/entities/schedule_list_entity.dart';
import 'package:dongsoop/domain/schedule/repository/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ScheduleDataSource _dataSource;

  ScheduleRepositoryImpl(this._dataSource);

  @override
  Future<List<ScheduleListEntity>> fetchScheduleList({
    required DateTime currentMonth,
  }) async {
    return _handle(() async {
      final models = await _dataSource.fetchScheduleList(
        currentMonth: currentMonth,
      );
      return models.map((model) => model.toEntity()).toList();
    }, CalendarException());
  }

  @override
  Future<List<ScheduleListEntity>> fetchGuestSchedule({
    required DateTime currentMonth,
  }) async {
    return _handle(() async {
      final models = await _dataSource.fetchGuestSchedule(
        currentMonth: currentMonth,
      );
      return models.map((model) => model.toEntity()).toList();
    }, CalendarException());
  }

  @override
  Future<void> submitSchedule({
    required ScheduleEntity entity,
  }) async {
    return _handle(() async {
      await _dataSource.submitSchedule(entity: entity);
    }, CalendarActionException());
  }

  @override
  Future<void> updateSchedule({
    required ScheduleEntity entity,
  }) async {
    return _handle(() async {
      await _dataSource.updateSchedule(entity: entity);
    }, CalendarActionException());
  }

  @override
  Future<void> deleteSchedule({
    required int calendarId,
  }) async {
    return _handle(() async {
      await _dataSource.deleteSchedule(calendarId: calendarId);
    }, CalendarActionException());
  }

  Future<T> _handle<T>(Future<T> Function() action, Exception exception) async {
    try {
      return await action();
    } catch (_) {
      throw exception;
    }
  }
}
