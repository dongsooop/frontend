enum NotificationType {
  notice('NOTICE'),
  timetable('TIMETABLE'),
  calendar('CALENDAR'),
  chat('CHAT'),

  tutoringApplicant('RECRUITMENT_TUTORING_APPLY'),
  tutoringAppliedResult('RECRUITMENT_TUTORING_APPLY_RESULT'),

  studyApplicant('RECRUITMENT_STUDY_APPLY'),
  studyAppliedResult('RECRUITMENT_STUDY_APPLY_RESULT'),

  projectApplicant('RECRUITMENT_PROJECT_APPLY'),
  projectAppliedResult('RECRUITMENT_PROJECT_APPLY_RESULT'),

  marketing('MARKETING'),
  blindDate('BLINDDATE'),
  feedback('FEEDBACK');

  final String code;
  const NotificationType(this.code);

  static NotificationType fromCode(String code) {
    return NotificationType.values.firstWhere(
          (e) => e.code == code,
      orElse: () => throw ArgumentError('Unknown NotificationType: $code'),
    );
  }
}
