import 'package:dongsoop/data/eclass/model/eclass_assignments_response.dart';

enum EclassSyncRemoteResult {
  completed,
  rateLimited,
}

abstract class EclassAssignmentDataSource {
  Future<EclassAssignmentsResponse> getAssignments({
    String? fid,
    String? deviceToken,
  });

  Future<EclassSyncRemoteResult> sync({
    String? fid,
    String? deviceToken,
  });
}
