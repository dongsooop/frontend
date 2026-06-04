// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_write_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackWriteRequest _$FeedbackWriteRequestFromJson(
        Map<String, dynamic> json) =>
    FeedbackWriteRequest(
      feature:
          (json['feature'] as List<dynamic>).map((e) => e as String).toList(),
      improvementSuggestions: json['improvementSuggestions'] as String,
      featureRequests: json['featureRequests'] as String,
    );

Map<String, dynamic> _$FeedbackWriteRequestToJson(
        FeedbackWriteRequest instance) =>
    <String, dynamic>{
      'feature': instance.feature,
      'improvementSuggestions': instance.improvementSuggestions,
      'featureRequests': instance.featureRequests,
    };
