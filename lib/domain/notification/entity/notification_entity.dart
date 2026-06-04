class NotificationEntity {
  final int id;
  final String title;
  final String body;
  final String type;
  final String value;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.value,
    required this.isRead,
    required this.createdAt,
  });
}