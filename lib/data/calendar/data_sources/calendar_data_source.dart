import 'package:dongsoop/data/calendar/models/calendar_list_model.dart';
import 'package:dongsoop/domain/calendar/entities/calendar_entity.dart';

abstract class CalendarDataSource {
  Future<List<CalendarListModel>> fetchCalendarList({
    required int memberId,
    required DateTime currentMonth,
  });

  Future<void> submitCalendar({
    required CalendarEntity entity,
  });

  Future<void> updateCalendar({
    required CalendarEntity entity,
  });

  Future<void> deleteCalendar({
    required int calendarId,
  });
}
