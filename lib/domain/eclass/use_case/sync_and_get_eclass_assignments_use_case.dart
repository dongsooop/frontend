import 'package:dongsoop/core/exception/eclass_exception.dart';
import 'package:dongsoop/domain/eclass/entity/eclass_assignment_list_entity.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_assignment_repository.dart';

class SyncAndGetEclassAssignmentsUseCase {
  final EclassAssignmentRepository _repository;

  SyncAndGetEclassAssignmentsUseCase(this._repository);

  Future<EclassAssignmentListEntity> execute({
    String? fid,
    String? deviceToken,
  }) async {
    try {
      await _repository.sync(
        fid: fid,
        deviceToken: deviceToken,
      );
    } on EclassNotLinkedException {
      // GET 응답으로 미연동 상태를 확정해 화면 상태를 갱신한다.
    }

    return _repository.getAssignments(
      fid: fid,
      deviceToken: deviceToken,
    );
  }
}
