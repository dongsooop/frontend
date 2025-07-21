import 'package:dongsoop/domain/board/recruit/entities/recruit_text_filter_entity.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_repository.dart';

class RecruitTextFilterUseCase {
  final RecruitRepository repository;

  RecruitTextFilterUseCase(this.repository);

  Future<void> execute({
    required RecruitTextFilterEntity entity,
  }) async {
    return repository.filterPost(entity: entity);
  }
}
