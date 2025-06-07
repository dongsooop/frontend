import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';

abstract class RecruitDetailRepository {
  Future<RecruitDetailEntity> fetchRecruitDetail({
    required int id,
    required RecruitType type,
  });
}
