import 'package:dongsoop/domain/timetable/enum/week_day.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timetable.freezed.dart';
part 'timetable.g.dart';

@freezed
@JsonSerializable()
class Timetable with _$Timetable {
  final int id;
  final String name;
  final String professor;
  final String location;
  final WeekDay week;
  final String startAt;
  final String endAt;

  const Timetable({
    required this.id,
    required this.name,
    required this.professor,
    required this.location,
    required this.week,
    required this.startAt,
    required this.endAt,
  });

  factory Timetable.fromJson(Map<String, dynamic> json) => _$TimetableFromJson(json);
  Map<String, dynamic> toJson() => _$TimetableToJson(this);
}