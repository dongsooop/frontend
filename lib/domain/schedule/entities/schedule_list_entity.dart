import 'package:dongsoop/domain/schedule/enum/schedule_type.dart';

class ScheduleListEntity {
  final int? id;
  final String title;
  final String? location;
  final DateTime startAt;
  final DateTime endAt;
  final ScheduleType type;

  const ScheduleListEntity({
    this.id,
    required this.title,
    this.location,
    required this.startAt,
    required this.endAt,
    required this.type,
  });
}