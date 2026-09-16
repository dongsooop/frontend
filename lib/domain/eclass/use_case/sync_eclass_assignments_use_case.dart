import 'package:dongsoop/domain/eclass/enum/eclass_sync_result.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_assignment_repository.dart';

class SyncEclassAssignmentsUseCase {
  final EclassAssignmentRepository _repository;

  SyncEclassAssignmentsUseCase(this._repository);

  Future<EclassSyncResult> execute({
    String? fid,
    String? deviceToken,
  }) {
    return _repository.sync(
      fid: fid,
      deviceToken: deviceToken,
    );
  }
}
