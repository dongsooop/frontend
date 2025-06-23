class RecruitDetailEntity {
  final int id;
  final int volunteer;
  final DateTime startAt;
  final DateTime endAt;
  final String title;
  final String content;
  final String tags;
  final List<String> departmentTypeList;
  final DateTime createdAt;
  final String author;
  final String viewType;
  final bool isAlreadyApplied;

  const RecruitDetailEntity({
    required this.id,
    required this.volunteer,
    required this.startAt,
    required this.endAt,
    required this.title,
    required this.content,
    required this.tags,
    required this.departmentTypeList,
    required this.createdAt,
    required this.author,
    required this.viewType,
    required this.isAlreadyApplied,
  });
}
