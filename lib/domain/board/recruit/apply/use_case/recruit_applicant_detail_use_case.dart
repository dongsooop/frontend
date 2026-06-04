import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/enum/recruit_applicant_viewer.dart';
import 'package:dongsoop/domain/board/recruit/apply/repository/recruit_apply_repository.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

class RecruitApplicantDetailUseCase {
  final RecruitApplyRepository repository;

  RecruitApplicantDetailUseCase(this.repository);

  Future<RecruitApplicantDetailEntity> execute({
    required RecruitApplicantViewer viewer,
    required RecruitType type,
    required int boardId,
    int? memberId,
  }) {
    switch (viewer) {
      case RecruitApplicantViewer.OWNER:
        return repository.recruitApplicantDetail(
          type: type,
          boardId: boardId,
          memberId: memberId!,
        );

      case RecruitApplicantViewer.APPLICANT:
        return repository.recruitApplicantDetailStatus(
          type: type,
          boardId: boardId,
        );
    }
  }
}
