import 'package:dongsoop/domain/board/recruit/entities/detail/recruit_detail_entity.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

abstract class RecruitDetailRepository {
  Future<RecruitDetailEntity> fetchRecruitDetail({
    required int id,
    required RecruitType type,
    required String accessToken,
  });
}
