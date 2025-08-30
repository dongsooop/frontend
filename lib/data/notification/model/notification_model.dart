import 'package:dongsoop/domain/notification/entity/notification_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
@JsonSerializable()
class NotificationModel with _$NotificationModel {
  final int id;
  final String title;
  final String body;
  final String type;
  final String value;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.value,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

extension NotificationModelMapper on NotificationModel {
  NotificationEntity toEntity() {

    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      type: type,
      value: value,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}