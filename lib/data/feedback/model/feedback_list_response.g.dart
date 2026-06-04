// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackListResponse _$FeedbackListResponseFromJson(
        Map<String, dynamic> json) =>
    FeedbackListResponse(
      serviceFeatures: (json['serviceFeatures'] as List<dynamic>)
          .map((e) => FeatureCountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      improvementSuggestions: (json['improvementSuggestions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      featureRequests: (json['featureRequests'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$FeedbackListResponseToJson(
        FeedbackListResponse instance) =>
    <String, dynamic>{
      'serviceFeatures': instance.serviceFeatures,
      'improvementSuggestions': instance.improvementSuggestions,
      'featureRequests': instance.featureRequests,
    };
