import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_entity.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

abstract class RecruitApplyRepository {
  Future<void> submitRecruitApply({
    required RecruitType type,
    required RecruitApplyEntity entity,
  });

  Future<List<RecruitApplicantListEntity>> recruitApplicantList({
    required RecruitType type,
    required int boardId,
  });

  Future<RecruitApplicantDetailEntity> recruitApplicantDetail({
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
