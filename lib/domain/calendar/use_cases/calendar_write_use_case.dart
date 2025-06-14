import 'package:dongsoop/domain/calendar/entities/calendar_entity.dart';
import 'package:dongsoop/domain/calendar/repository/calendar_repository.dart';
import 'package:dongsoop/main.dart';

class CalendarWriteUseCase {
  final CalendarRepository repository;

  CalendarWriteUseCase(this.repository);

  Future<void> execute({
    required CalendarEntity entity,
  }) {
    logger.i('[Calendar_Write_UseCase] 호출됨');

    if (entity.id != null) {
      logger.i('[Calendar_Write_UseCase] 수정 요청');
      return repository.updateCalendar(entity: entity);
    } else {
      logger.i('[Calendar_Write_UseCase] 생성 요청');
      return repository.submitCalendar(entity: entity);
    }
  }
}
