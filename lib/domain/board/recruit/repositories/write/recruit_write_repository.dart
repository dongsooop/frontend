import 'package:dongsoop/domain/board/recruit/entities/write/recruit_write_entity.dart';

abstract class RecruitWriteRepository {
  Future<void> recruitWrite(RecruitWriteEntity entity);
}
