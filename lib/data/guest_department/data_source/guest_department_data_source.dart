import 'package:dongsoop/data/guest_department/model/guest_department_model.dart';

abstract class GuestDepartmentDataSource {
  Future<GuestDepartmentModel> fetchDepartments({
    required String deviceToken,
  });

  Future<void> updateDepartments({
    required String deviceToken,
    required GuestDepartmentModel body,
  });
}
