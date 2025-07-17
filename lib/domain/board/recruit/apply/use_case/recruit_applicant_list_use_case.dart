import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/repository/recruit_apply_repository.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/main.dart';

class RecruitApplicantListUseCase {
  final RecruitApplyRepository repository;

  RecruitApplicantListUseCase(this.repository);

  Future<List<RecruitApplicantListEntity>> execute({
    required RecruitType type,
    required int boardId,
  }) {
    logger.i('[APPLYCANT_LIST_USECASE] 호출');
    return repository.recruitApplicantList(
      type: type,
      boardId: boardId,
    );
  }
}
