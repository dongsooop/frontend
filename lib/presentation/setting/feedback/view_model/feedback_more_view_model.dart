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

  Future<void> load({int size = 20}) async {
    if (state.isLoading) return;
    await _loadInternal(page: 0, size: size, append: false);
  }

  Future<void> loadMore({int size = 20}) async {
    if (state.isLoadingMore || !state.hasMore) return;

    final nextPage = state.page + 1;
    await _loadInternal(page: nextPage, size: size, append: true);
  }

  Future<void> _loadInternal({
    required int page,
    required int size,
    required bool append,
  }) async {
    if (append) {
      state = state.copyWith(
        isLoadingMore: true,
        errMessage: null,
      );
    } else {
      state = state.copyWith(
        isLoading: true,
        errMessage: null,
      );
    }

    try {
      final items = await _useCase.execute(
        type: type,
        page: page,
        size: size,
      );

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        page: page,
        hasMore: items.length == size,
        items: append ? [...state.items, ...items] : items,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
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
