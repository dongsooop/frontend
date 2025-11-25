import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/domain/feedback/entity/feedback_write_entity.dart';
import 'package:dongsoop/domain/feedback/enum/service_feature.dart';
import 'package:dongsoop/domain/feedback/use_case/feedback_write_use_case.dart';
import 'package:dongsoop/presentation/setting/feedback/providers/feedback_use_case_provider.dart';
import 'package:dongsoop/presentation/setting/feedback/view_model/state/feedback_write_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feedback_write_view_model.g.dart';

@riverpod
class FeedbackWriteViewModel extends _$FeedbackWriteViewModel {
  FeedbackWriteUseCase get _useCase => ref.watch(feedbackWriteUseCaseProvider);

  bool _submitting = false;

  @override
  FeedbackWriteState build() => const FeedbackWriteState();

  void toggleFeature(ServiceFeature feature) {
    final list = [...state.serviceFeatureList];
    if (list.contains(feature)) {
      list.remove(feature);
    } else {
      if (list.length >= 3) return;
      list.add(feature);
    }
    state = state.copyWith(serviceFeatureList: list);
  }

  void updateImprovementSuggestions(String value) {
    final error = _validateText(value);
    state = state.copyWith(
      improvementSuggestions: value,
      improvementError: error,
    );
  }

  void updateFeatureRequests(String value) {
    final error = _validateText(value);
    state = state.copyWith(
      featureRequests: value,
      featureError: error,
    );
  }

  String? _validateText(String value) {
    if (value.isEmpty) {
      return '내용을 입력해 주세요.';
    }
    if (value.length > 150) {
      return '150자 이내로 입력해 주세요.';
    }
    return null;
  }

  bool get isFormValid =>
      state.improvementError == null &&
          state.featureError == null &&
          state.improvementSuggestions.isNotEmpty &&
          state.featureRequests.isNotEmpty &&
          state.serviceFeatureList.length >= 1 &&   // 최소 1개
          state.serviceFeatureList.length <= 3;     // 최대 3개

  Future<bool> submit() async {
    if (_submitting) return false;
    if (!isFormValid) return false;

    _submitting = true;
    state = state.copyWith(isLoading: true, errMessage: null);

    try {
      final entity = FeedbackWriteEntity(
        serviceFeatureList: state.serviceFeatureList,
        improvementSuggestions: state.improvementSuggestions,
        featureRequests: state.featureRequests,
      );

      await _useCase.execute(entity: entity);
      return true;

    } on FeedbackSubmitException catch (e) {
      state = state.copyWith(errMessage: e.message);
      return false;

    } catch (e) {
      state = state.copyWith(errMessage: "알 수 없는 오류가 발생했어요");
      return false;

    } finally {
      _submitting = false;
      state = state.copyWith(isLoading: false);
    }
  }
}
