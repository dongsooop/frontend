import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_repository.dart';
import 'package:dongsoop/main.dart';

class RecruitWriteUseCase {
  final RecruitRepository repository;

  RecruitWriteUseCase(this.repository);

  Future<void> execute({
    required RecruitType type,
    required RecruitWriteEntity entity,
  }) {
    logger.i('[USECASE] 호출됨');
    return repository.submitRecruitPost(
      type: type,
      entity: entity,
    );
  }
}
