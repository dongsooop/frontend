import 'package:dongsoop/domain/notification/entity/notification_response_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dongsoop/data/notification/model/notification_model.dart';

part 'notification_response_model.freezed.dart';
part 'notification_response_model.g.dart';

@freezed
@JsonSerializable()
class NotificationResponseModel with _$NotificationResponseModel {
  final int unreadCount;
  @JsonKey(name: 'notificationLists')
  final List<NotificationModel> items;

  const NotificationResponseModel({
    required this.unreadCount,
    required this.items,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationResponseModelFromJson(json);
}

extension NotificationResponseModelMapper on NotificationResponseModel {
  NotificationResponseEntity toEntity() {
    return NotificationResponseEntity(
      unreadCount: unreadCount,
      items: items.map((m) => m.toEntity()).toList(),
    );
  }
}