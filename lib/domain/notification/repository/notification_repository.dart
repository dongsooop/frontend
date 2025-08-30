import 'package:dongsoop/domain/notification/entity/notification_response_entity.dart';

abstract class NotificationRepository {
  Future<NotificationResponseEntity> fetchNotificationList({
    required int page,
    required int size,
  });

  Future<void> readNotification({required int id});
  Future<void> deleteNotification({required int id});
}