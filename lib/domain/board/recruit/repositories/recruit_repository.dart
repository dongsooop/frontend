import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';

abstract class RecruitRepository {
  Future<List<RecruitListEntity>> fetchRecruitList({
    required RecruitType type,
    required int page,
    required String departmentType,
  });

  Future<RecruitDetailEntity> fetchRecruitDetail({
    required int id,
    required RecruitType type,
  });

  Future<void> submitRecruitPost({
    required RecruitType type,
    required RecruitWriteEntity entity,
  });
}
