import 'package:dongsoop/domain/guest_department/repository/guest_department_repository.dart';

class UpdateGuestDepartmentsUseCase {
  final GuestDepartmentRepository _repository;
  UpdateGuestDepartmentsUseCase(this._repository);

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
