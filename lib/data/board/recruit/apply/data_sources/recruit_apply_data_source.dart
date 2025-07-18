import 'package:dongsoop/data/board/recruit/apply/models/recruit_applicant_detail_model.dart';
import 'package:dongsoop/data/board/recruit/apply/models/recruit_applicant_list_model.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

abstract class RecruitApplyDataSource {
  Future<void> submitRecruitApply({
    required RecruitType type,
    required RecruitApplyEntity entity,
  });

  Future<List<RecruitApplicantListModel>> recruitApplicantList({
    required RecruitType type,
    required int boardId,
  });

  Future<RecruitApplicantDetailModel> recruitApplicantDetail({
    required RecruitType type,
    required int boardId,
    required int memberId,
  });

  Future<void> recruitDecision({
    required RecruitType type,
    required int boardId,
    required int applierId,
    required String status,
  });
}
