import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_recruit_model.freezed.dart';
part 'notification_recruit_model.g.dart';

@freezed
@JsonSerializable()
class NotificationRecruitModel with _$NotificationRecruitModel {
  final String deviceToken;
  final bool targetState;

  NotificationRecruitModel({
    required this.deviceToken,
    required this.targetState,
  });

  Map<String, dynamic> toJson() => _$NotificationRecruitModelToJson(this);
}