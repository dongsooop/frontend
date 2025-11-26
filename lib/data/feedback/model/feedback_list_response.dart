import 'package:dongsoop/data/feedback/model/feature_count_model.dart';
import 'package:dongsoop/domain/feedback/entity/feedback_list_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_list_response.freezed.dart';
part 'feedback_list_response.g.dart';

@freezed
@JsonSerializable()
class FeedbackListResponse with _$FeedbackListResponse {
  final List<FeatureCountModel> serviceFeatures;
  final List<String> improvementSuggestions;
  final List<String> featureRequests;

  FeedbackListResponse({
    required this.serviceFeatures,
    required this.improvementSuggestions,
    required this.featureRequests,
  });

  factory FeedbackListResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedbackListResponseFromJson(json);
}

extension FeedbackListResponseMapper on FeedbackListResponse {
  FeedbackListEntity toEntity() {
    return FeedbackListEntity(
      serviceFeatures: serviceFeatures.map((e) => e.toEntity()).toList(),
      improvementSuggestions: improvementSuggestions,
      featureRequests: featureRequests,
    );
  }
}