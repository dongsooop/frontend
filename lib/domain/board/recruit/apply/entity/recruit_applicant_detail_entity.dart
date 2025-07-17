class RecruitApplicantDetailEntity {
  final int boardId;
  final String title;
  final int applierId;
  final String applierName;
  final String departmentName;
  final String status;
  final DateTime applyTime;
  final String? introduction;
  final String? motivation;

  RecruitApplicantDetailEntity({
    required this.boardId,
    required this.title,
    required this.applierId,
    required this.applierName,
    required this.departmentName,
    required this.status,
    required this.applyTime,
    this.introduction,
    this.motivation,
  });
}
