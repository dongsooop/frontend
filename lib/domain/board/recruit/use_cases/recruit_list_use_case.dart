import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_list_repository.dart';
import 'package:dongsoop/presentation/board/common/enum/recruit_types.dart';

class RecruitListUseCase {
  final RecruitListRepository repository;

  RecruitListUseCase(this.repository);

  Future<List<RecruitListEntity>> call({
    required RecruitType type,
    required int page,
    required String departmentType,
  }) {
    return repository.fetchRecruitList(
      type: type,
      page: page,
      departmentType: departmentType,
    );
  }
}
