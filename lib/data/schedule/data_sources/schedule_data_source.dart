import 'package:dongsoop/data/schedule/models/schedule_list_model.dart';
import 'package:dongsoop/domain/schedule/entities/schedule_entity.dart';

abstract class ScheduleDataSource {
  Future<List<ScheduleListModel>> fetchScheduleList({
    required DateTime currentMonth,
  });

  Future<List<ScheduleListModel>> fetchGuestSchedule({
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
