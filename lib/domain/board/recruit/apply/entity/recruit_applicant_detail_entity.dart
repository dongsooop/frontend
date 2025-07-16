class RecruitApplicantDetailEntity {
  final int boardId;
  final int applierId;
  final String applierName;
  final String departmentName;
  final DateTime applyTime;
  final String? introduction;
  final String? motivation;

  RecruitApplicantDetailEntity({
    required this.boardId,
    required this.applierId,
    required this.applierName,
    required this.departmentName,
    required this.applyTime,
    this.introduction,
    this.motivation,
  });
}
