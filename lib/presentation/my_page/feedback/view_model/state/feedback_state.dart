import 'package:dongsoop/domain/feedback/entity/feature_count_entity.dart';

class FeedbackResultState {
  final bool isLoading;
  final String? errMessage;
  final List<FeedbackCountEntity> serviceFeatures;
  final List<String> improvementSuggestions;
  final List<String> featureRequests;

  const FeedbackResultState({
    this.isLoading = false,
    this.errMessage,
    this.serviceFeatures = const [],
    this.improvementSuggestions = const [],
    this.featureRequests = const [],
  });

  int get totalResponseCount =>
      serviceFeatures.fold(0, (sum, e) => sum + e.count);

  bool get hasData =>
      serviceFeatures.isNotEmpty ||
          improvementSuggestions.isNotEmpty ||
          featureRequests.isNotEmpty;

  FeedbackResultState copyWith({
    bool? isLoading,
    String? errMessage,
    List<FeedbackCountEntity>? serviceFeatures,
    List<String>? improvementSuggestions,
    List<String>? featureRequests,
  }) {
    return FeedbackResultState(
      isLoading: isLoading ?? this.isLoading,
      errMessage: errMessage,
      serviceFeatures: serviceFeatures ?? this.serviceFeatures,
      improvementSuggestions:
      improvementSuggestions ?? this.improvementSuggestions,
      featureRequests: featureRequests ?? this.featureRequests,
    );
  }
}
