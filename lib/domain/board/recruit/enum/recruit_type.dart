enum RecruitType {
  tutoring,
  study,
  project;

  String get label {
    switch (this) {
      case RecruitType.tutoring:
        return '튜터링';
      case RecruitType.study:
        return '스터디';
      case RecruitType.project:
        return '프로젝트';
    }
  }
}