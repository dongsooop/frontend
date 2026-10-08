enum NotificationType {
  notice('NOTICE'),
  timetable('TIMETABLE'),
  calendar('CALENDAR'),
  eclassAssignment('ECLASS_ASSIGNMENT'),
  chat('CHAT'),

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
