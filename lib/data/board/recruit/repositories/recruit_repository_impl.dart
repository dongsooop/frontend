import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/board/recruit/data_sources/recruit_data_source.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_detail_model.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_list_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_text_filter_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_repository.dart';

class RecruitRepositoryImpl implements RecruitRepository {
  final RecruitDataSource _dataSource;

  RecruitRepositoryImpl(this._dataSource);

  @override
  Future<List<RecruitListEntity>> fetchRecruitList({
    required RecruitType type,
    required int page,
    String? departmentType,
  }) async {
    return _handle(() async {
      final models = await _dataSource.fetchList(
        type: type,
        page: page,
        departmentType: departmentType,
      );
      return models.map((model) => model.toEntity()).toList();
    }, RecruitListException());
  }

  @override
  Future<RecruitDetailEntity> fetchRecruitDetail({
    required int id,
    required RecruitType type,
  }) async {
    return _handle(() async {
      final model = await _dataSource.fetchDetail(
        id: id,
        type: type,
      );
      return model.toEntity();
    }, RecruitDetailException());
  }

  @override
  Future<void> filterPost({
    required RecruitTextFilterEntity entity,
  }) async {
    return _handle(() async {
      await _dataSource.filterPost(entity: entity);
    }, RecruitWriteException());
  }

  @override
  Future<void> submitRecruitPost({
    required RecruitType type,
    required RecruitWriteEntity entity,
  }) async {
    return _handle(() async {
      await _dataSource.submitPost(type: type, entity: entity);
    }, RecruitWriteException());
  }

  @override
  Future<void> deleteRecruitPost({
    required int id,
    required RecruitType type,
  }) async {
    return _handle(() async {
      await _dataSource.deletePost(id: id, type: type);
    }, RecruitDeleteException());
  }

  Future<T> _handle<T>(Future<T> Function() action, Exception exception) async {
    try {
      return await action();
    } on ProfanityDetectedException {
      rethrow;
    } on NotFoundBoardException {
      rethrow;
    }
    catch (_) {
      throw exception;
    }
  }
}
