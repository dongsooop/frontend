import 'package:dongsoop/domain/subscribe_department/repository/subscribe_department_repository.dart';

class GetSubscribeDepartmentsUseCase {
  final SubscribeDepartmentRepository _repository;
  GetSubscribeDepartmentsUseCase(this._repository);

  Future<List<String>> execute({required String deviceToken}) {
    return _repository.getDepartments(deviceToken: deviceToken);
  }
}
