class NoticeEntity {
  final int id;
  final DateTime createdAt;
  final String title;
  final String link;
  final bool isDepartment;

  const NoticeEntity({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.link,
    required this.isDepartment,
  });
}
