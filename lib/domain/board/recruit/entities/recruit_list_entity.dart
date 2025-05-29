class RecruitListEntity {
  final int id;
  final int volunteer;
  final DateTime startAt;
  final DateTime endAt;
  final String title;
  final String content;
  final String tags;
  final bool state;

  const RecruitListEntity({
    required this.id,
    required this.volunteer,
    required this.startAt,
    required this.endAt,
    required this.title,
    required this.content,
    required this.tags,
    required this.state,
  });
}
