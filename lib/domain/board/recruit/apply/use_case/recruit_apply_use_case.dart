import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/repository/recruit_apply_repository.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';
import 'package:dongsoop/main.dart';

class RecruitApplyUseCase {
  final RecruitApplyRepository repository;

  RecruitApplyUseCase(this.repository);

  Future<void> execute({
    required RecruitType type,
    required RecruitApplyEntity entity,
  }) {
    logger.i('[APPLY_USECASE] 호출');
    return repository.submitRecruitApply(
      type: type,
      entity: entity,
    );
  }
}
