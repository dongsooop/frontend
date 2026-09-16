import 'package:freezed_annotation/freezed_annotation.dart';

part 'eclass_assignment_response.freezed.dart';
part 'eclass_assignment_response.g.dart';

@freezed
@JsonSerializable(createToJson: false)
class EclassAssignmentResponse with _$EclassAssignmentResponse {
  final int id;
  final int assignId;
  final String courseName;
  final String title;
  final DateTime dueAt;
  final DateTime? cutoffAt;
  final int dDay;
  final bool submitted;
  final String link;

  EclassAssignmentResponse({
    required this.id,
    required this.assignId,
    required this.courseName,
    required this.title,
    required this.dueAt,
    required this.cutoffAt,
    required this.dDay,
    required this.submitted,
    required this.link,
  });

  factory EclassAssignmentResponse.fromJson(Map<String, dynamic> json) =>
      _$EclassAssignmentResponseFromJson(json);
}
