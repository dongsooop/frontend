import 'package:dongsoop/data/board/recruit/models/recruit_detail_model.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_list_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_text_filter_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

abstract class RecruitDataSource {
  Future<List<RecruitListModel>> fetchList({
    required RecruitType type,
    required int page,
    required String? departmentType,
  });

  Future<RecruitDetailModel> fetchDetail({
    required int id,
    required RecruitType type,
  });

  Future<void> filterPost({
    required RecruitTextFilterEntity entity,
  });

  Future<void> submitPost({
    required RecruitType type,
    required RecruitWriteEntity entity,
  });

  Future<void> deletePost({
    required int id,
    required RecruitType type,
  });
}
