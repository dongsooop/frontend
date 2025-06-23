import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_entity.dart';
import 'package:dongsoop/domain/board/recruit/apply/use_case/recruit_apply_use_case.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_apply_use_case_provider.dart';
import 'package:dongsoop/presentation/board/recruit/detail/view_models/recruit_detail_view_model.dart';
import 'package:dongsoop/presentation/board/recruit/list/view_models/recruit_list_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recruit_apply_view_model.g.dart';

@riverpod
class RecruitApplyViewModel extends _$RecruitApplyViewModel {
  late final RecruitApplyUseCase _useCase;

  @override
  FutureOr<void> build() {
    _useCase = ref.read(recruitApplyUseCaseProvider);
  }

  Future<bool> submitRecruitApply({
    required int boardId,
    required String introduction,
    required String motivation,
    required RecruitType type,
    required String departmentCode,
  }) async {
    state = const AsyncLoading();

    final entity = RecruitApplyEntity(
      boardId: boardId,
      introduction: introduction,
      motivation: motivation,
    );

    try {
      await _useCase.execute(entity: entity, type: type);
      logger.i('지원 성공 - 서버 응답 완료');

      // 비동기 상태 갱신 - await 없이
      ref.invalidate(
        recruitDetailViewModelProvider(
          RecruitDetailArgs(id: boardId, type: type),
        ),
      );
      ref
          .read(
            recruitListViewModelProvider(
              type: type,
              departmentCode: departmentCode,
            ).notifier,
          )
          .refresh();

      if (state is! AsyncData) {
        state = const AsyncData(null); // 안전하게 완료 상태로 설정
      }
      return true;
    } catch (e, st) {
      if (state.isLoading) {
        logger.e('지원 실패', error: e, stackTrace: st);
        state = AsyncError(e, st);
      } else {
        logger.w('지원 실패 시도 - 이미 완료된 상태');
      }
      return false;
    }
  }
}
