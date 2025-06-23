import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_repository.dart';

class RecruitListUseCase {
  final RecruitRepository repository;

  RecruitListUseCase(this.repository);

  Future<List<RecruitListEntity>> execute({
    required RecruitType type,
    required int page,
    String? departmentType,
  }) {
    return repository.fetchRecruitList(
      type: type,
      page: page,
      departmentType: departmentType,
    );
  }
}
