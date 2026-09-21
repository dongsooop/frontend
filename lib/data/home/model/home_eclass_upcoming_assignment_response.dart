import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_eclass_upcoming_assignment_response.freezed.dart';
part 'home_eclass_upcoming_assignment_response.g.dart';

@freezed
@JsonSerializable()
class HomeEclassUpcomingAssignmentResponse
    with _$HomeEclassUpcomingAssignmentResponse {
  final String courseName;
  final String title;
  final DateTime dueAt;
  final int dDay;
  final bool submitted;

  const HomeEclassUpcomingAssignmentResponse({
    required this.courseName,
    required this.title,
    required this.dueAt,
    required this.dDay,
    required this.submitted,
  });

  factory HomeEclassUpcomingAssignmentResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$HomeEclassUpcomingAssignmentResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$HomeEclassUpcomingAssignmentResponseToJson(this);
}
