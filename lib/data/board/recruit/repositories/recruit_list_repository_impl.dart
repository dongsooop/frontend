import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/board/recruit/data_sources/recruit_list_data_source.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_list_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_list_repository.dart';

class RecruitListRepositoryImpl implements RecruitListRepository {
  final RecruitListDataSource dataSource;

  RecruitListRepositoryImpl(this.dataSource);

  @override
  Future<List<RecruitListEntity>> fetchRecruitList({
    required RecruitType type,
    required int page,
    required String departmentType,
  }) async {
    try {
      final models = await dataSource.fetchRecruitList(
        type: type,
        page: page,
        departmentType: departmentType,
      );

      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw RecruitListException();
    }
  }
}
