import 'package:dongsoop/domain/calendar/repository/calendar_repository.dart';

class CalendarDeleteUseCase {
  final CalendarRepository repository;

  CalendarDeleteUseCase(this.repository);

  Future<void> execute({required int calendarId}) {
    return repository.deleteCalendar(calendarId: calendarId);
  }
}
