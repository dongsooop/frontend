import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';

abstract class RecruitListRepository {
  Future<List<RecruitListEntity>> fetchRecruitList({
    required RecruitType type,
    required int page,
    required String departmentType,
  });
}
