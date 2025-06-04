import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_detail_repository.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

class RecruitDetailUseCase {
  final RecruitDetailRepository repository;

  RecruitDetailUseCase(this.repository);

  Future<RecruitDetailEntity> call({
    required int id,
    required RecruitType type,
  }) {
    return repository.fetchRecruitDetail(
      id: id,
      type: type,
    );
  }
}
