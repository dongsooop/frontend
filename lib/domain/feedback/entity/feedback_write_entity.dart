import 'package:dongsoop/domain/feedback/enum/service_feature.dart';

class FeedbackWriteEntity {
  final List<ServiceFeature> serviceFeatureList;
  final String improvementSuggestions;
  final String featureRequests;

  FeedbackWriteEntity({
    required this.serviceFeatureList,
    required this.improvementSuggestions,
    required this.featureRequests,
  });
}