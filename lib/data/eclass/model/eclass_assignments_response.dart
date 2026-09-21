import 'package:dongsoop/data/eclass/model/eclass_assignment_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'eclass_assignments_response.freezed.dart';
part 'eclass_assignments_response.g.dart';

@freezed
@JsonSerializable(createToJson: false)
class EclassAssignmentsResponse with _$EclassAssignmentsResponse {
  final bool linked;
  final String? status;
  final List<EclassAssignmentResponse> assignments;

  EclassAssignmentsResponse({
    required this.linked,
    required this.status,
    required this.assignments,
  });

  factory EclassAssignmentsResponse.fromJson(Map<String, dynamic> json) =>
      _$EclassAssignmentsResponseFromJson(json);
}
