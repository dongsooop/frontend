import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/use_case/recruit_applicant_list_use_case.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/board/providers/recruit/apply/recruit_applicant_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recruit_applicant_list_view_model.g.dart';

@riverpod
class RecruitApplicantListViewModel extends _$RecruitApplicantListViewModel {
  RecruitApplicantListUseCase get _useCase =>
      ref.read(recruitApplicantUseCaseProvider);

  @override
  FutureOr<List<RecruitApplicantListEntity>> build({
    required RecruitType type,
    required int boardId,
  }) async {
    try {
      final list = await _useCase.execute(type: type, boardId: boardId);
      return list;
    } catch (e, st) {
      logger.e('지원자 목록 조회 실패', error: e, stackTrace: st);
      throw e;
    }
  }

  Future<void> refresh({
    required RecruitType type,
    required int boardId,
  }) async {
    state = const AsyncLoading();

    try {
      final list = await _useCase.execute(type: type, boardId: boardId);
      state = AsyncData(list);
    } catch (e, st) {
      logger.e('지원자 목록 새로고침 실패', error: e, stackTrace: st);
      state = AsyncError(e, st);
    }
  }
}
