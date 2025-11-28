import 'package:dongsoop/domain/feedback/entity/feedback_list_entity.dart';
import 'package:dongsoop/domain/feedback/use_case/feedback_use_case.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/presentation/my_page/feedback/providers/feedback_use_case_provider.dart';
import 'package:dongsoop/presentation/my_page/feedback/view_model/state/feedback_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feedback_view_model.g.dart';

@riverpod
class FeedbackResultViewModel extends _$FeedbackResultViewModel {
  FeedbackUseCase get _useCase => ref.watch(feedbackUseCaseProvider);

  @override
  FeedbackResultState build() {
    return const FeedbackResultState();
  }

  Future<void> load() async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      errMessage: null,
    );

    try {
      final entity = await _useCase.execute();

      state = state.copyWith(
        isLoading: false,
        serviceFeatures: entity.serviceFeatures,
        improvementSuggestions: entity.improvementSuggestions,
        featureRequests: entity.featureRequests,
      );

    } on FeedbackException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errMessage: e.message,
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errMessage: '알 수 없는 오류가 발생했어요',
      );
    }
  }

  Future<String> exportCsv() async {
    final csvUseCase = ref.read(feedbackCsvUseCaseProvider);

    final entity = FeedbackListEntity(
      serviceFeatures: state.serviceFeatures,
      improvementSuggestions: state.improvementSuggestions,
      featureRequests: state.featureRequests,
    );

    return await csvUseCase.execute(entity);
  }
}