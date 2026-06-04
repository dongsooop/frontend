import 'package:dongsoop/domain/schedule/enum/schedule_type.dart';

class ScheduleTypeMapper {
  static ScheduleType fromApi(String raw) {
    switch (raw.toUpperCase()) {
      case 'OFFICIAL': return ScheduleType.official;
      case 'MEMBER':   return ScheduleType.member;
      default: throw Exception('Unknown ScheduleType: $raw');
    }
  }

  static String toApi(ScheduleType type) {
    switch (type) {
      case ScheduleType.official: return 'OFFICIAL';
      case ScheduleType.member:   return 'MEMBER';
    }
  }
}
