import 'package:dongsoop/domain/eclass/entity/eclass_assignment_list_entity.dart';
import 'package:dongsoop/domain/eclass/enum/eclass_sync_result.dart';

abstract class EclassAssignmentRepository {
  Future<EclassAssignmentListEntity> getAssignments({
    String? fid,
    String? deviceToken,
  });

  Future<EclassSyncResult> sync({
    String? fid,
    String? deviceToken,
  });
}
