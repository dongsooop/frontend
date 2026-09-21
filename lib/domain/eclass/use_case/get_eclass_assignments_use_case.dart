import 'package:dongsoop/domain/eclass/entity/eclass_assignment_list_entity.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_assignment_repository.dart';

class GetEclassAssignmentsUseCase {
  final EclassAssignmentRepository _repository;

  GetEclassAssignmentsUseCase(this._repository);

  Future<EclassAssignmentListEntity> execute({
    String? fid,
    String? deviceToken,
  }) {
    return _repository.getAssignments(
      fid: fid,
      deviceToken: deviceToken,
    );
  }
}
