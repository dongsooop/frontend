import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_enable_model.freezed.dart';
part 'notification_enable_model.g.dart';

@freezed
@JsonSerializable()
class NotificationEnableModel with _$NotificationEnableModel {
  final String deviceToken;
  final String notificationType;

  NotificationEnableModel({
    required this.deviceToken,
    required this.notificationType,
  });

  Map<String, dynamic> toJson() => _$NotificationEnableModelToJson(this);
}