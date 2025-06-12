import 'package:dongsoop/domain/notice/entity/notice_entity.dart';

abstract class NoticeRepository {
  Future<List<NoticeEntity>> fetchSchoolNotices(
      {required int page, bool force = false});
  Future<List<NoticeEntity>> fetchDepartmentNotices({
    required int page,
    required String departmentType,
    bool force = false,
  });
}
