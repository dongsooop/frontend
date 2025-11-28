import 'package:dongsoop/domain/feedback/enum/service_feature.dart';

class FeedbackWriteState {
  final List<ServiceFeature> serviceFeatureList;
  final String improvementSuggestions;
  final String featureRequests;
  final bool isLoading;
  final String? improvementError;
  final String? featureError;
  final String? errMessage;

  const FeedbackWriteState({
    this.serviceFeatureList = const [],
    this.improvementSuggestions = '',
    this.featureRequests = '',
    this.isLoading = false,
    this.improvementError,
    this.featureError,
    this.errMessage,
  });

  FeedbackWriteState copyWith({
    List<ServiceFeature>? serviceFeatureList,
    String? improvementSuggestions,
    String? featureRequests,
    bool? isLoading,
    String? improvementError,
    String? featureError,
    String? errMessage,
  }) {
    return FeedbackWriteState(
      serviceFeatureList: serviceFeatureList ?? this.serviceFeatureList,
      improvementSuggestions:
      improvementSuggestions ?? this.improvementSuggestions,
      featureRequests: featureRequests ?? this.featureRequests,
      isLoading: isLoading ?? this.isLoading,
      improvementError: improvementError,
      featureError: featureError,
      errMessage: errMessage ?? this.errMessage,
    );
  }
}