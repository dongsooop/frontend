class SearchNoticeEntity {
  final int id;
  final String title;
  final String authorName;
  final DateTime createdAt;
  final String url;
  final bool isDepartment;

  const SearchNoticeEntity({
    required this.id,
    required this.title,
    required this.authorName,
    required this.createdAt,
    required this.url,
    required this.isDepartment,
  });
}