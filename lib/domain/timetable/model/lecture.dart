import 'package:dongsoop/domain/timetable/enum/week_day.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lecture.freezed.dart';
part 'lecture.g.dart';

@freezed
@JsonSerializable()
class Lecture with _$Lecture {
  final int id;
  final String name;
  final String? professor;
  final String? location;
  final WeekDay week;
  final String startAt;
  final String endAt;

  const Lecture({
    required this.id,
    required this.name,
    required this.professor,
    required this.location,
    required this.week,
    required this.startAt,
    required this.endAt,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) => _$LectureFromJson(json);
  Map<String, dynamic> toJson() => _$LectureToJson(this);
}