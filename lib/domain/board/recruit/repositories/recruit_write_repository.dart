import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

abstract class RecruitWriteRepository {
  Future<void> fetchRecruitWrite({
    required RecruitType type,
    required String accessToken,
    required RecruitWriteEntity entity,
  });
}
