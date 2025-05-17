class TutoringWriteEntity {
  final String title;
  final String content;
  final String tags;
  final int recruitmentCapacity;
  final DateTime startAt;
  final DateTime endAt;
  final String departmentType;

  TutoringWriteEntity({
    required this.title,
    required this.content,
    required this.tags,
    required this.recruitmentCapacity,
    required this.startAt,
    required this.endAt,
    required this.departmentType,
  });
}
