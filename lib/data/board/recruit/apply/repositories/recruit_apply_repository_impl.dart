import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/board/recruit/apply/data_sources/recruit_apply_data_source.dart';
import 'package:dongsoop/data/board/recruit/apply/models/recruit_applicant_detail_model.dart';
import 'package:dongsoop/data/board/recruit/apply/models/recruit_applicant_list_model.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_text_filter_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/repository/recruit_apply_repository.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

class RecruitApplyRepositoryImpl implements RecruitApplyRepository {
  final RecruitApplyDataSource _dataSource;

  RecruitApplyRepositoryImpl(this._dataSource);

  @override
  Future<void> filterApply({
    required RecruitApplyTextFilterEntity entity,
  }) async {
    return _handle(() async {
      await _dataSource.filterApply(entity: entity);
    }, RecruitApplyException());
  }

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

  @override
  Future<RecruitApplicantDetailEntity> recruitApplicantDetail({
    required RecruitType type,
    required int boardId,
    required int memberId,
  }) async {
    return _handle(() async {
      final model = await _dataSource.recruitApplicantDetail(
          type: type, boardId: boardId, memberId: memberId);
      return model.toEntity();
    }, RecruitApplicantDetailException());
  }

  @override
  Future<RecruitApplicantDetailEntity> recruitApplicantDetailStatus({
    required RecruitType type,
    required int boardId,
  }) async {
    return _handle(() async {
      final model = await _dataSource.recruitApplicantDetailStatus(
          type: type, boardId: boardId);
      return model.toEntity();
    }, RecruitApplicantStatusException());
  }

  @override
  Future<void> recruitDecision({
    required RecruitType type,
    required int boardId,
    required int applierId,
    required String status,
  }) async {
    return _handle(() async {
      final model = await _dataSource.recruitDecision(
        type: type,
        boardId: boardId,
        applierId: applierId,
        status: status,
      );
      return model;
    }, RecruitApplicantException());
  }

  Future<T> _handle<T>(Future<T> Function() action, Exception exception) async {
    try {
      return await action();
    } on ProfanityDetectedException {
      rethrow;
    } catch (_) {
      throw exception;
    }
  }
}
