import 'package:dongsoop/domain/board/recruit/apply/repository/recruit_apply_repository.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

class RecruitDecisionUseCase {
  final RecruitApplyRepository repository;

  RecruitDecisionUseCase(this.repository);

  Future<void> execute({
    required RecruitType type,
    required int boardId,
    required String status,
    required int applierId,
  }) {
    return repository.recruitDecision(
      type: type,
      boardId: boardId,
      status: status,
      applierId: applierId,
    );
  }
}
