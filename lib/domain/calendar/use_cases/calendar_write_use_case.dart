import 'package:dongsoop/domain/calendar/entities/calendar_entity.dart';
import 'package:dongsoop/domain/calendar/repository/calendar_repository.dart';

class CalendarWriteUseCase {
  final CalendarRepository repository;

  CalendarWriteUseCase(this.repository);

  Future<void> execute({
    required CalendarEntity entity,
  }) {
    if (entity.id != null) {
      return repository.updateCalendar(entity: entity);
    } else {
      return repository.submitCalendar(entity: entity);
    }
  }
}
