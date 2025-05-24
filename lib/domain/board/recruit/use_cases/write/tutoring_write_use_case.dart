import 'package:dongsoop/domain/board/recruit/entities/write/tutoring_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/repositories/write/tutoring_write_repository.dart';

class TutoringWriteUseCase {
  final TutoringRepository repository;

  TutoringWriteUseCase(this.repository);

  Future<void> call(TutoringWriteEntity entity) {
    return repository.tutoringWrite(entity);
  }
}
