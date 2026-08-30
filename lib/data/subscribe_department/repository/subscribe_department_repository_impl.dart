import 'package:dongsoop/data/subscribe_department/data_source/subscribe_department_data_source.dart';
import 'package:dongsoop/data/subscribe_department/model/subscribe_department_model.dart';
import 'package:dongsoop/domain/subscribe_department/repository/subscribe_department_repository.dart';

class SubscribeDepartmentRepositoryImpl implements SubscribeDepartmentRepository {
  final SubscribeDepartmentDataSource _dataSource;

  SubscribeDepartmentRepositoryImpl(this._dataSource);

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
      body: SubscribeDepartmentModel(departmentTypes: departmentTypes),
    );
  }
}
