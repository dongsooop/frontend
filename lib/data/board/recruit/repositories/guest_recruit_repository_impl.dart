import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/board/recruit/data_sources/guest_recruit_data_source.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_detail_model.dart';
import 'package:dongsoop/data/board/recruit/models/recruit_list_model.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_text_filter_entity.dart';
import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/board/recruit/repositories/recruit_repository.dart';

class GuestRecruitRepositoryImpl implements RecruitRepository {
  final GuestRecruitDataSource _dataSource;

  GuestRecruitRepositoryImpl(this._dataSource);

  @override
  Future<List<RecruitListEntity>> fetchRecruitList({
    required RecruitType type,
    required int page,
    String? departmentType,
  }) async {
    return _handle(() async {
      final models = await _dataSource.fetchGuestList(
        type: type,
        page: page,
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
      final model = await _dataSource.fetchGuestDetail(
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
    // 이중 방어
    throw LoginRequiredException();
  }

  @override
  Future<void> submitRecruitPost({
    required RecruitType type,
    required RecruitWriteEntity entity,
  }) {
    // 이중 방어
    throw LoginRequiredException();
  }

  @override
  Future<void> deleteRecruitPost({
    required int id,
    required RecruitType type,
  }) {
    // 이중 방어
    throw LoginRequiredException();
  }

  Future<T> _handle<T>(
    Future<T> Function() action,
    Exception exception,
  ) async {
    try {
      return await action();
    } catch (_) {
      throw exception;
    }
  }
}
