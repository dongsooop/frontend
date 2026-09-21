enum NotificationType {
  notice('NOTICE'),
  timetable('TIMETABLE'),
  calendar('CALENDAR'),
  eclassAssignment('ECLASS_ASSIGNMENT'),
  chat('CHAT'),

  tutoringApplicant('RECRUITMENT_TUTORING_APPLY'),
  tutoringAppliedResult('RECRUITMENT_TUTORING_APPLY_RESULT'),

  studyApplicant('RECRUITMENT_STUDY_APPLY'),
  studyAppliedResult('RECRUITMENT_STUDY_APPLY_RESULT'),

  projectApplicant('RECRUITMENT_PROJECT_APPLY'),
  projectAppliedResult('RECRUITMENT_PROJECT_APPLY_RESULT'),

  newDevice('NEW_DEVICE_LOGIN'),

  marketing('MARKETING'),
  blindDate('BLINDDATE'),
  feedback('FEEDBACK');

  final String code;
  const NotificationType(this.code);

  static NotificationType? tryFromCode(String code) {
    for (final type in NotificationType.values) {
      if (type.code == code) return type;
    }
    return null;
  }

  static NotificationType fromCode(String code) {
    final type = tryFromCode(code);
    if (type == null) {
      throw ArgumentError('Unknown NotificationType: $code');
    }
    return type;
  }
}
