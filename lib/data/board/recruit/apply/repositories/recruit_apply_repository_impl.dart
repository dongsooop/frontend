import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/board/recruit/apply/data_sources/recruit_apply_data_source.dart';
import 'package:dongsoop/data/board/recruit/apply/models/recruit_applicant_list_model.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/repository/recruit_apply_repository.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

class RecruitApplyRepositoryImpl implements RecruitApplyRepository {
  final RecruitApplyDataSource _dataSource;

  RecruitApplyRepositoryImpl(this._dataSource);

  @override
  Future<void> submitRecruitApply({
    required RecruitType type,
    required RecruitApplyEntity entity,
  }) async {
    return _handle(() async {
      await _dataSource.submitRecruitApply(type: type, entity: entity);
    }, RecruitApplyException());
  }

  @override
  Future<List<RecruitApplicantListEntity>> recruitApplicantList({
    required RecruitType type,
    required int boardId,
  }) async {
    return _handle(() async {
      final models = await _dataSource.recruitApplicantList(
        type: type,
        boardId: boardId,
      );
      return models.map((model) => model.toEntity()).toList();
    }, RecruitApplicantListException());
  }

  Future<T> _handle<T>(Future<T> Function() action, Exception exception) async {
    try {
      return await action();
    } catch (_) {
      throw exception;
    }
  }
}
