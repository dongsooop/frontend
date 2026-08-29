abstract class GuestDepartmentRepository {
  Future<List<String>> getDepartments({
    required String deviceToken,
  });

  Future<void> updateDepartments({
    required String deviceToken,
    required List<String> departmentTypes,
  });
}
