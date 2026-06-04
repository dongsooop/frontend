import 'package:dongsoop/domain/schedule/entities/schedule_entity.dart';
import 'package:dongsoop/domain/schedule/entities/schedule_list_entity.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleListEntity>> fetchScheduleList({
    required DateTime currentMonth,
  });

  Future<List<ScheduleListEntity>> fetchGuestSchedule({
    required DateTime currentMonth,
  });

  Future<void> submitSchedule({
    required ScheduleEntity entity,
  });

  Future<void> updateSchedule({
    required ScheduleEntity entity,
  });

  Future<void> deleteSchedule({
    required int calendarId,
  });
}
