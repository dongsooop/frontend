class RecruitWriteEntity {
  final String title;
  final String content;
  final String tags;
  final DateTime startAt;
  final DateTime endAt;
  final List<String> departmentTypeList;

  RecruitWriteEntity({
    required this.title,
    required this.content,
    required this.tags,
    required this.startAt,
    required this.endAt,
    required this.departmentTypeList,
  });
}
