import 'package:dongsoop/domain/schedule/repository/schedule_repository.dart';

class ScheduleDeleteUseCase {
  final ScheduleRepository repository;

  ScheduleDeleteUseCase(this.repository);

  Future<void> execute({required int calendarId}) {
    return repository.deleteSchedule(calendarId: calendarId);
  }
}
