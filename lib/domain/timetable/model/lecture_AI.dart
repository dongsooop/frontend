import 'package:dongsoop/domain/timetable/enum/week_day.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lecture_AI.freezed.dart';
part 'lecture_AI.g.dart';

@freezed
@JsonSerializable()
class LectureAi with _$LectureAi {
  final String name;
  final String? professor;
  final String? location;
  final WeekDay week;
  final String startAt;
  final String endAt;

  const LectureAi({
    required this.name,
    required this.professor,
    required this.location,
    required this.week,
    required this.startAt,
    required this.endAt,
  });

  factory LectureAi.fromJson(Map<String, dynamic> json) => _$LectureAiFromJson(json);
  Map<String, dynamic> toJson() => _$LectureAiToJson(this);
}