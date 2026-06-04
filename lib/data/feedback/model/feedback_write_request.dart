import 'package:dongsoop/domain/feedback/entity/feedback_write_entity.dart';
import 'package:dongsoop/domain/feedback/enum/service_feature.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_write_request.freezed.dart';
part 'feedback_write_request.g.dart';

@freezed
@JsonSerializable()
class FeedbackWriteRequest with _$FeedbackWriteRequest {
  final List<String> feature;
  final String improvementSuggestions;
  final String featureRequests;

  FeedbackWriteRequest({
    required this.feature,
    required this.improvementSuggestions,
    required this.featureRequests,
  });

  Map<String, dynamic> toJson() => _$FeedbackWriteRequestToJson(this);

  factory FeedbackWriteRequest.fromEntity(FeedbackWriteEntity entity) {
    return FeedbackWriteRequest(
      feature: entity.serviceFeatureList.map((e) => _enumToServerString(e)).toList(),
      improvementSuggestions: entity.improvementSuggestions,
      featureRequests: entity.featureRequests,
    );
  }
}

String _enumToServerString(ServiceFeature f) {
  switch (f) {
    case ServiceFeature.noticeAlert:
      return 'NOTICE_ALERT';
    case ServiceFeature.mealInformation:
      return 'MEAL_INFORMATION';
    case ServiceFeature.academicSchedule:
      return 'ACADEMIC_SCHEDULE';
    case ServiceFeature.timetableAutoManage:
      return 'TIMETABLE_AUTO_MANAGE';
    case ServiceFeature.teamRecruitment:
      return 'TEAM_RECRUITMENT';
    case ServiceFeature.marketplace:
      return 'MARKETPLACE';
    case ServiceFeature.chatbotCampusInfo:
      return 'CHATBOT_CAMPUS_INFO';
  }
}