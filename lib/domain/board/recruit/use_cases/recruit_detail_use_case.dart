import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_repository.dart';

class RecruitDetailUseCase {
  final RecruitRepository repository;

  RecruitDetailUseCase(this.repository);

  Future<RecruitDetailEntity> execute({
    required int id,
    required RecruitType type,
  }) {
    return repository.fetchRecruitDetail(
      id: id,
      type: type,
    );
  }
}
