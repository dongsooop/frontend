import 'package:dongsoop/data/guest_department/data_source/guest_department_data_source.dart';
import 'package:dongsoop/data/guest_department/model/guest_department_model.dart';
import 'package:dongsoop/domain/guest_department/repository/guest_department_repository.dart';

class GuestDepartmentRepositoryImpl implements GuestDepartmentRepository {
  final GuestDepartmentDataSource _dataSource;

  GuestDepartmentRepositoryImpl(this._dataSource);

  @override
  Future<List<String>> getDepartments({
    required String deviceToken,
  }) async {
    final model = await _dataSource.fetchDepartments(deviceToken: deviceToken);
    return model.departmentTypes;
  }

  @override
  Future<void> updateDepartments({
    required String deviceToken,
    required List<String> departmentTypes,
  }) {
    return _dataSource.updateDepartments(
      deviceToken: deviceToken,
      body: GuestDepartmentModel(departmentTypes: departmentTypes),
    );
  }
}
