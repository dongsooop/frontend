import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/repository/recruit_apply_repository.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

class RecruitApplicantDetailUseCase {
  final RecruitApplyRepository repository;

  RecruitApplicantDetailUseCase(this.repository);

  Future<RecruitApplicantDetailEntity> execute({
    required RecruitType type,
    required int boardId,
    required int memberId,
  }) {
    return repository.recruitApplicantDetail(
      type: type,
      boardId: boardId,
      memberId: memberId,
    );
  }
}
