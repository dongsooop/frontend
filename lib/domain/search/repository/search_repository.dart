import 'package:dongsoop/domain/search/entity/search_notice_entity.dart';

abstract class SearchRepository {
  Future<List<SearchNoticeEntity>> searchOfficialNotice({
    required int page,
    required String keyword,
    required int size,
    required String sort,
  });

  Future<List<SearchNoticeEntity>> searchDeptNotice({
    required int page,
    required String keyword,
    required String departmentName,
    required int size,
    required String sort,
  });
}