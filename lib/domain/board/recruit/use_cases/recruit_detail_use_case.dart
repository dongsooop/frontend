import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/params/recruit_detail_params.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_detail_repository.dart';

class RecruitDetailUseCase {
  final RecruitDetailRepository repository;

  RecruitDetailUseCase(this.repository);

  Future<RecruitDetailEntity> call(RecruitDetailParams params) async {
    try {
      final recruit = await repository.fetchRecruitDetail(params);
      return recruit;
    } catch (e) {
      rethrow;
    }
  }
}
