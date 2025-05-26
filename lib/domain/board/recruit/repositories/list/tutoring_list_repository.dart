import 'package:dongsoop/domain/board/recruit/entities/list/recruit_list_entity.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

abstract class RecruitListRepository {
  Future<List<RecruitListEntity>> fetchRecruitList({
    required RecruitType type,
    required int page,
    required String accessToken,
    required String departmentType,
  });
}
