import 'package:dongsoop/domain/eclass/entity/eclass_assignment_entity.dart';
import 'package:dongsoop/domain/eclass/enum/eclass_link_status.dart';

class EclassAssignmentListEntity {
  final bool linked;
  final EclassLinkStatus? status;
  final List<EclassAssignmentEntity> assignments;

  const EclassAssignmentListEntity({
    required this.linked,
    required this.status,
    required this.assignments,
  });

  bool get isUnlinked => !linked;

  bool get isExpired => linked && status == EclassLinkStatus.expired;

  bool get hasNoAssignments =>
      linked && status == EclassLinkStatus.active && assignments.isEmpty;
}
