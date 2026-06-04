import 'notification_entity.dart';

class NotificationResponseEntity {
  final int unreadCount;
  final List<NotificationEntity> items;

  const NotificationResponseEntity({
    required this.unreadCount,
    required this.items,
  });
}