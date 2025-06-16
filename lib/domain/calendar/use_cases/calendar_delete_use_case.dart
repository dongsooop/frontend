import 'package:dongsoop/domain/calendar/repository/calendar_repository.dart';
import 'package:dongsoop/main.dart';

class CalendarDeleteUseCase {
  final CalendarRepository repository;

  CalendarDeleteUseCase(this.repository);

  Future<void> execute({required int calendarId}) {
    logger.i('[Calendar_Delete_UseCase] 호출됨');
    return repository.deleteCalendar(calendarId: calendarId);
  }
}
