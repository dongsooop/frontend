import 'package:dongsoop/domain/board/recruit/apply/use_case/recruit_decision_use_case.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/board/providers/recruit/apply/recruit_decision_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recruit_decision_view_model.g.dart';

@riverpod
class RecruitDecisionViewModel extends _$RecruitDecisionViewModel {
  RecruitDecisionUseCase get _useCase =>
      ref.watch(recruitDecisionUseCaseProvider);

  @override
  FutureOr<void> build() async {
    // 초기 상태 없음
  }

  Future<void> decide({
    required RecruitType type,
    required int boardId,
    required String status,
    required int applierId,
  }) async {
    state = const AsyncLoading();

    try {
      await _useCase.execute(
        type: type,
        boardId: boardId,
        status: status,
        applierId: applierId,
      );
      state = const AsyncData(null);
    } catch (e, st) {
      logger.e('[RECRUIT] 합불 결정 실패', error: e, stackTrace: st);
      state = AsyncError(e, st);
    }
  }
}
