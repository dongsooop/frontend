import 'package:dongsoop/data/eclass/mapper/eclass_link_mapper.dart';
import 'package:dongsoop/data/eclass/model/eclass_assignment_response.dart';
import 'package:dongsoop/data/eclass/model/eclass_assignments_response.dart';
import 'package:dongsoop/domain/eclass/entity/eclass_assignment_entity.dart';
import 'package:dongsoop/domain/eclass/entity/eclass_assignment_list_entity.dart';
import 'package:dongsoop/domain/eclass/enum/eclass_link_status.dart';

extension EclassAssignmentsResponseMapper on EclassAssignmentsResponse {
  EclassAssignmentListEntity toEntity() {
    final mappedStatus = mapEclassLinkStatus(status);

    if (!linked) {
      if (mappedStatus != null || assignments.isNotEmpty) {
        throw const FormatException(
          'Unlinked Eclass assignment response contains linked data.',
        );
      }
    } else if (mappedStatus == null) {
      throw const FormatException(
        'Linked Eclass assignment response has no status.',
      );
    }

    if (mappedStatus == EclassLinkStatus.expired && assignments.isNotEmpty) {
      throw const FormatException(
        'Expired Eclass assignment response contains assignments.',
      );
    }

    return EclassAssignmentListEntity(
      linked: linked,
      status: mappedStatus,
      assignments: List.unmodifiable(
        assignments.map((assignment) => assignment.toEntity()),
      ),
    );
  }
}

extension EclassAssignmentResponseMapper on EclassAssignmentResponse {
  EclassAssignmentEntity toEntity() {
    return EclassAssignmentEntity(
      id: id,
      assignId: assignId,
      courseName: courseName,
      title: title,
      dueAt: dueAt,
      cutoffAt: cutoffAt,
      dDay: dDay,
      submitted: submitted,
      link: link,
    );
  }
}
