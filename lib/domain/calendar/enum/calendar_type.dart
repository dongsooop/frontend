enum CalendarType {
  official,
  member,
}

extension CalendarTypeExtension on CalendarType {
  static CalendarType fromString(String type) {
    switch (type.toUpperCase()) {
      case 'OFFICIAL':
        return CalendarType.official;
      case 'MEMBER':
        return CalendarType.member;
      default:
        throw Exception('Unknown CalendarType: $type');
    }
  }

  static String toStringValue(CalendarType type) {
    switch (type) {
      case CalendarType.official:
        return 'OFFICIAL';
      case CalendarType.member:
        return 'MEMBER';
    }
  }
}
