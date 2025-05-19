import 'package:dongsoop/domain/notice/entites/notice_entity.dart';

abstract class NoticeRepository {
  Future<List<NoticeEntity>> fetchSchoolNotices({required int page});
  Future<List<NoticeEntity>> fetchDepartmentNotices({
    required int page,
    required String departmentType,
  });
}
