import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

abstract class RecruitApplyDataSource {
  Future<void> submitRecruitApply({
    required RecruitType type,
    required RecruitApplyEntity entity,
  });
}
