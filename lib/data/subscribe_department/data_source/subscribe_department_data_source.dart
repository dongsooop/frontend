import 'package:dongsoop/data/subscribe_department/model/subscribe_department_model.dart';

abstract class SubscribeDepartmentDataSource {
  Future<SubscribeDepartmentModel> fetchDepartments({
    required String deviceToken,
  });

  Future<void> updateDepartments({
    required String deviceToken,
    required SubscribeDepartmentModel body,
  });
}
