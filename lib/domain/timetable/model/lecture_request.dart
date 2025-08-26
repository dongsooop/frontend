import 'package:dongsoop/domain/timetable/enum/week_day.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lecture_request.freezed.dart';
part 'lecture_request.g.dart';

@freezed
@JsonSerializable()
class LectureRequest with _$LectureRequest {
  final String name;
  final String professor;
  final String location;
  final WeekDay week;
  final String startAt;
  final String endAt;
  final int year;
  final String semester;

  const LectureRequest({
    required this.name,
    required this.professor,
    required this.location,
    required this.week,
    required this.startAt,
    required this.endAt,
    required this.year,
    required this.semester
  });

  Map<String, dynamic> toJson() => _$LectureRequestToJson(this);
}