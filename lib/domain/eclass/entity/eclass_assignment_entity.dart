class EclassAssignmentEntity {
  final int id;
  final int assignId;
  final String courseName;
  final String title;

  /// 서버의 KST LocalDateTime을 그대로 보존한다. 화면에서 시간대 변환하지 않는다.
  final DateTime dueAt;
  final DateTime? cutoffAt;

  /// 날짜 경계가 서버와 달라지지 않도록 앱에서 다시 계산하지 않는다.
  final int dDay;
  final bool submitted;
  final String link;

  const EclassAssignmentEntity({
    required this.id,
    required this.assignId,
    required this.courseName,
    required this.title,
    required this.dueAt,
    required this.cutoffAt,
    required this.dDay,
    required this.submitted,
    required this.link,
  });
}
