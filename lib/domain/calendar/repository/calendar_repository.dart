import 'package:dongsoop/domain/calendar/entities/calendar_entity.dart';
import 'package:dongsoop/domain/calendar/entities/calendar_list_entity.dart';

abstract class CalendarRepository {
  Future<List<CalendarListEntity>> fetchCalendarList({
    required DateTime currentMonth,
  });

  Future<List<CalendarListEntity>> fetchGuestCalendar({
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
