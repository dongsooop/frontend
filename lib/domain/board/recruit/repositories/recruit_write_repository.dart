import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

abstract class RecruitWriteRepository {
  Future<void> submitRecruitPost({
    required RecruitType type,
    required RecruitWriteEntity entity,
  });
}
