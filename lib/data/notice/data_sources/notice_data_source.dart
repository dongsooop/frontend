import 'package:dongsoop/data/notice/model/notice_model.dart';

abstract class NoticeDataSource {
  Future<List<NoticeModel>> fetchSchoolNotices({
    required int page,
  });

  Future<List<NoticeModel>> fetchDepartmentNotices({
    required int page,
    required String departmentType,
  });
}
