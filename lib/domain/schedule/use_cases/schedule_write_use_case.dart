import 'package:dongsoop/domain/schedule/entities/schedule_entity.dart';
import 'package:dongsoop/domain/schedule/repository/schedule_repository.dart';

class ScheduleWriteUseCase {
  final ScheduleRepository repository;

  ScheduleWriteUseCase(this.repository);

  Future<void> execute({
    required ScheduleEntity entity,
  }) {
    if (entity.id != null) {
      return repository.updateSchedule(entity: entity);
    } else {
      return repository.submitSchedule(entity: entity);
    }
  }
}
