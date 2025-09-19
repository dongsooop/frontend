import 'package:dongsoop/data/search/model/search_notice_model.dart';
import 'package:dongsoop/data/search/model/search_recruit_model.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

abstract class SearchDataSource {
  Future<List<SearchNoticeModel>> searchOfficialNotice({
    required int page,
    required String keyword,
    required int size,
    required String sort,
  });

  Future<List<SearchNoticeModel>> searchDeptNotice({
    required int page,
    required String keyword,
    required String departmentName,
    required int size,
    required String sort,
  });

  Future<List<SearchRecruitModel>> searchRecruit({
    required int page,
    required String keyword,
    required RecruitType type,
    required String departmentName,
    required int size,
    required String sort,
  });
}