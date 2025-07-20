import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_text_filter_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/repository/recruit_apply_repository.dart';

class RecruitApplyTextFilterUseCase {
  final RecruitApplyRepository repository;

  RecruitApplyTextFilterUseCase(this.repository);

  /// 비속어 감지용 호출
  Future<void> execute({
    required RecruitApplyTextFilterEntity entity,
  }) async {
    return repository.filterApply(entity: entity);
  }
}
