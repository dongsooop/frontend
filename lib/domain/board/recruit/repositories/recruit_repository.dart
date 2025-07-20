import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_text_filter_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

abstract class RecruitRepository {
  Future<List<RecruitListEntity>> fetchRecruitList({
    required RecruitType type,
    required int page,
    String? departmentType,
  });

  Future<RecruitDetailEntity> fetchRecruitDetail({
    required int id,
    required RecruitType type,
  });

  Future<void> filterPost({
    required RecruitTextFilterEntity entity,
  });

  Future<void> submitRecruitPost({
    required RecruitType type,
    required RecruitWriteEntity entity,
  });

  Future<void> deleteRecruitPost({
    required int id,
    required RecruitType type,
  });
}
