import 'package:dongsoop/data/home/model/home_eclass_upcoming_assignment_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_eclass_assignment_response.freezed.dart';
part 'home_eclass_assignment_response.g.dart';

@freezed
@JsonSerializable()
class HomeEclassAssignmentResponse with _$HomeEclassAssignmentResponse {
  final bool linked;
  final String? status;
  final int upcomingCount;
  final List<HomeEclassUpcomingAssignmentResponse>? upcoming;
  final String? nearestCourseName;
  final String? nearestTitle;
  final DateTime? nearestDueAt;
  final int? nearestDDay;

  const HomeEclassAssignmentResponse({
    required this.linked,
    required this.status,
    required this.upcomingCount,
    this.upcoming,
    this.nearestCourseName,
    this.nearestTitle,
    this.nearestDueAt,
    this.nearestDDay,
  });

  factory HomeEclassAssignmentResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeEclassAssignmentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HomeEclassAssignmentResponseToJson(this);
}
