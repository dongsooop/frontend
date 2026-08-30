abstract class SubscribeDepartmentRepository {
  Future<List<String>> getDepartments({
    String? fid,
    required String deviceToken,
  });

  Future<void> updateDepartments({
    required String deviceToken,
    required List<String> departmentTypes,
  });
}
