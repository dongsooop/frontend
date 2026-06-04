enum RecruitType {
  TUTORING,
  STUDY,
  PROJECT;

  String get label {
    switch (this) {
      case RecruitType.TUTORING:
        return '튜터링';
      case RecruitType.STUDY:
        return '스터디';
      case RecruitType.PROJECT:
        return '프로젝트';
    }
  }
}