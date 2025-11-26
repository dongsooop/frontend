import 'package:dongsoop/domain/feedback/enum/feedback_type.dart';
import 'package:dongsoop/domain/feedback/use_case/feedback_more_use_case.dart';
import 'package:dongsoop/presentation/setting/feedback/providers/feedback_use_case_provider.dart';
import 'package:dongsoop/presentation/setting/feedback/view_model/state/feedback_more_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feedback_more_view_model.g.dart';

@riverpod
class FeedbackMoreViewModel extends _$FeedbackMoreViewModel {
  FeedbackMoreUseCase get _useCase => ref.watch(feedbackMoreUseCaseProvider);

  @override
  FeedbackMoreState build(FeedbackType type) {
    return const FeedbackMoreState();
  }

  Future<void> load() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      errMessage: null,
    );

    try {
      final items = await _useCase.execute(type);

      state = state.copyWith(
        isLoading: false,
        items: items,
        hasMore: false, // 페이징 없음
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errMessage: _errorMessageByType(type),
      );
    }
  }

  String _errorMessageByType(FeedbackType type) {
    switch (type) {
      case FeedbackType.improvement:
        return '개선 의견 조회 중 오류가 발생했어요.\n잠시 후 다시 시도해주세요.';
      case FeedbackType.featureRequest:
        return '추가 기능 요청 조회 중 오류가 발생했어요.\n잠시 후 다시 시도해주세요.';
    }
  }
}
