import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';

abstract class RecruitWriteRepository {
  Future<void> submitRecruitPost({
    required RecruitType type,
    required RecruitWriteEntity entity,
  });
}
