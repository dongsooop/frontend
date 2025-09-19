import 'package:dongsoop/data/search/model/search_notice_model.dart';

abstract class SearchDataSource {
  Future<List<SearchNoticeModel>> searchOfficialNotice({
    required int page,
    required String keyword,
  });

  Future<List<SearchNoticeModel>> searchDeptNotice({
    required int page,
    required String keyword,
    required String departmentName,
  });
}