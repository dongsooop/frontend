import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_detail_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/use_case/recruit_applicant_detail_use_case.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/board/providers/recruit/apply/recruit_applicant_detail_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recruit_applicant_detail_view_model.g.dart';

class RecruitApplicantDetailArgs {
  final RecruitType type;
  final int boardId;
  final int memberId;

  const RecruitApplicantDetailArgs({
    required this.type,
    required this.boardId,
    required this.memberId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecruitApplicantDetailArgs &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          boardId == other.boardId;

  @override
  int get hashCode => type.hashCode ^ boardId.hashCode;
}

@riverpod
class RecruitApplicantDetailViewModel
    extends _$RecruitApplicantDetailViewModel {
  RecruitApplicantDetailUseCase get _useCase =>
      ref.watch(recruitApplicantDetailUseCaseProvider);

  @override
  FutureOr<RecruitApplicantDetailEntity> build(
      RecruitApplicantDetailArgs args) async {
    try {
      final detail = await _useCase.execute(
        type: args.type,
        boardId: args.boardId,
        memberId: args.memberId,
      );
      return detail;
    } catch (e, st) {
      logger.e('[RECRUIT] 지원자 상세 조회 실패', error: e, stackTrace: st);
      throw e;
    }
  }

  Future<void> refresh(RecruitApplicantDetailArgs args) async {
    state = const AsyncLoading();

    try {
      final detail = await _useCase.execute(
        type: args.type,
        boardId: args.boardId,
        memberId: args.memberId,
      );
      state = AsyncData(detail);
    } catch (e, st) {
      logger.e('[RECRUIT] 지원자 상세 리프레시 실패', error: e, stackTrace: st);
      state = AsyncError(e, st);
    }
  }
}
