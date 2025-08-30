import 'package:dongsoop/data/notification/model/notification_response_model.dart';

abstract class NotificationDataSource {
  Future<NotificationResponseModel> fetchNotificationList({
    required int page,
    required int size,
  });

  Future<void> readNotification({required int id});

  Future<void> deleteNotification({required int id});
}