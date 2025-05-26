import 'package:dongsoop/domain/board/recruit/entities/write/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/repositories/write/recruit_write_repository.dart';

class RecruitWriteUseCase {
  final RecruitWriteRepository repository;

  RecruitWriteUseCase(this.repository);

  Future<void> call(RecruitWriteEntity entity) {
    return repository.recruitWrite(entity);
  }
}
