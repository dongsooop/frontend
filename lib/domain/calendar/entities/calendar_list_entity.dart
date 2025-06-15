import 'package:dongsoop/domain/calendar/enum/calendar_type.dart';

class CalendarListEntity {
  final int? id;
  final String title;
  final String location;
  final DateTime startAt;
  final DateTime endAt;
  final CalendarType type;

  const CalendarListEntity({
    required this.id,
    required this.title,
    required this.location,
    required this.startAt,
    required this.endAt,
    required this.type,
  });
}
