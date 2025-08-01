import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/use_case/recruit_applicant_list_use_case.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
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
      final sorted = _sortApplicants(list);
      return sorted;
    } catch (e) {
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
      final sorted = _sortApplicants(list);
      state = AsyncData(sorted);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  List<RecruitApplicantListEntity> _sortApplicants(
      List<RecruitApplicantListEntity> list) {
    return [...list]..sort((a, b) {
        if (a.status == 'APPLY' && b.status != 'APPLY') return -1;
        if (a.status != 'APPLY' && b.status == 'APPLY') return 1;
        return 0;
      });
  }
}
