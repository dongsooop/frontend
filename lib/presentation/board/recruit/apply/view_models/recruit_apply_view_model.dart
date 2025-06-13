import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/use_case/recruit_apply_use_case.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_types.dart';
import 'package:dongsoop/presentation/board/recruit/apply/providers/recruit_apply_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recruit_apply_view_model.g.dart';

@riverpod
class RecruitApplyViewModel extends _$RecruitApplyViewModel {
  late final RecruitApplyUseCase _useCase;

  @override
  FutureOr<void> build() {
    _useCase = ref.read(recruitApplyUseCaseProvider);
  }

  Future<void> submitRecruitApply({
    required int boardId,
    required String introduction,
    required String motivation,
    required RecruitType type,
  }) async {
    state = const AsyncLoading();

    final entity = RecruitApplyEntity(
      boardId: boardId,
      introduction: introduction,
      motivation: motivation,
    );

    try {
      await _useCase.execute(
        entity: entity,
        type: type,
      );
      state = const AsyncData(null); // 성공 처리
    } catch (e, st) {
      state = AsyncError(e, st); // 에러 처리
    }
  }
}
