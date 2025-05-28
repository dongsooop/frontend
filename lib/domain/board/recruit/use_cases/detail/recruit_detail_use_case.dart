import 'package:dongsoop/domain/board/recruit/entities/detail/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/repositories/detail/recruit_detail_repository.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

class RecruitDetailUseCase {
  final RecruitDetailRepository repository;

  RecruitDetailUseCase(this.repository);

  Future<RecruitDetailEntity> call({
    required int id,
    required RecruitType type,
    required String accessToken,
  }) async {
    try {
      final detail = await repository.fetchRecruitDetail(
        id: id,
        type: type,
        accessToken: accessToken,
      );
      return detail;
    } catch (e) {
      rethrow;
    }
  }
}
