import 'package:dongsoop/domain/subscribe_department/repository/subscribe_department_repository.dart';

class UpdateSubscribeDepartmentsUseCase {
  final SubscribeDepartmentRepository _repository;
  UpdateSubscribeDepartmentsUseCase(this._repository);

  Future<void> execute({
    required String deviceToken,
    required List<String> departmentTypes,
  }) {
    return _repository.updateDepartments(
      deviceToken: deviceToken,
      departmentTypes: departmentTypes,
    );
  }
}
