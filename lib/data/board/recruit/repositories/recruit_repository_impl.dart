import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/board/recruit/data_sources/recruit_data_source.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_detail_model.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_list_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_repository.dart';

class RecruitRepositoryImpl implements RecruitRepository {
  final RecruitDataSource dataSource;

  RecruitRepositoryImpl(this.dataSource);

  @override
  Future<List<RecruitListEntity>> fetchRecruitList({
    required RecruitType type,
    required int page,
    required String departmentType,
  }) async {
    try {
      final models = await dataSource.fetchList(
        type: type,
        page: page,
        departmentType: departmentType,
      );
      return models.map((model) => model.toEntity()).toList();
    } catch (_) {
      throw RecruitListException();
    }
  }

  @override
  Future<RecruitDetailEntity> fetchRecruitDetail({
    required int id,
    required RecruitType type,
  }) async {
    try {
      final model = await dataSource.fetchDetail(
        id: id,
        type: type,
      );
      return model.toEntity();
    } catch (_) {
      throw RecruitDetailException();
    }
  }

  @override
  Future<void> submitRecruitPost({
    required RecruitType type,
    required RecruitWriteEntity entity,
  }) async {
    try {
      await dataSource.submitPost(
        type: type,
        entity: entity,
      );
    } catch (_) {
      throw RecruitWriteException();
    }
  }
}
