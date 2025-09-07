import 'package:dongsoop/domain/calendar/enum/calendar_type.dart';

class CalendarTypeMapper {
  static CalendarType fromApi(String raw) {
    switch (raw.toUpperCase()) {
      case 'OFFICIAL': return CalendarType.official;
      case 'MEMBER':   return CalendarType.member;
      default: throw Exception('Unknown CalendarType: $raw');
    }
  }

  static String toApi(CalendarType type) {
    switch (type) {
      case CalendarType.official: return 'OFFICIAL';
      case CalendarType.member:   return 'MEMBER';
    }
  }
}
