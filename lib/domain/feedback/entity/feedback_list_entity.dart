import 'package:dongsoop/domain/feedback/entity/feature_count_entity.dart';

class FeedbackListEntity {
  final List<FeedbackCountEntity> serviceFeatures;
  final List<String> improvementSuggestions;
  final List<String> featureRequests;

  FeedbackListEntity({
    required this.serviceFeatures,
    required this.improvementSuggestions,
    required this.featureRequests,
  });
}