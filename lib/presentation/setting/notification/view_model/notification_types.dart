class NotificationTypes {
  static const notice = 'NOTICE';
  static const timetable = 'TIMETABLE';
  static const calendar = 'CALENDAR';
  static const chat = 'CHAT';

  // 모집 지원
  static const tutoringApplicant = 'RECRUITMENT_TUTORING_APPLY';
  static const studyApplicant = 'RECRUITMENT_STUDY_APPLY';
  static const projectApplicant = 'RECRUITMENT_PROJECT_APPLY';

  // 모집 결과
  static const tutoringAppliedResult = 'RECRUITMENT_TUTORING_APPLY_RESULT';
  static const studyAppliedResult = 'RECRUITMENT_STUDY_APPLY_RESULT';
  static const projectAppliedResult = 'RECRUITMENT_PROJECT_APPLY_RESULT';

  static const marketing = 'MARKETING';
  static const blinddate = 'BLINDDATE';
  static const feedback = 'FEEDBACK';

  static const recruitApplyGroup = <String>[
    tutoringApplicant,
    studyApplicant,
    projectApplicant,
  ];

  static const recruitResultGroup = <String>[
    tutoringAppliedResult,
    studyAppliedResult,
    projectAppliedResult,
  ];
}