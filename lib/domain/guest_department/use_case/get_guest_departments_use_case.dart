import 'package:dongsoop/domain/guest_department/repository/guest_department_repository.dart';

class GetGuestDepartmentsUseCase {
  final GuestDepartmentRepository _repository;
  GetGuestDepartmentsUseCase(this._repository);

  Future<List<String>> execute({required String deviceToken}) {
    return _repository.getDepartments(deviceToken: deviceToken);
  }
}
