import 'package:dongsoop/domain/board/recruit/entities/recruit_text_filter_entity.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_repository.dart';

class RecruitTextFilterUseCase {
  final RecruitRepository repository;

  RecruitTextFilterUseCase(this.repository);

  /// 비속어 감지용 호출
  Future<void> execute({
    required RecruitTextFilterEntity entity,
  }) async {
    return repository.filterPost(entity: entity);
  }
}
