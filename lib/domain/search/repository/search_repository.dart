import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/search/entity/search_market_entity.dart';
import 'package:dongsoop/domain/search/entity/search_notice_entity.dart';
import 'package:dongsoop/domain/search/entity/search_recruit_entity.dart';

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

  Future<List<SearchRecruitEntity>> searchRecruit({
    required int page,
    required String keyword,
    required RecruitType type,
    required String departmentName,
    required int size,
    required String sort,
  });

  Future<List<SearchMarketEntity>> searchMarket({
    required int page,
    required String keyword,
    required MarketType type,
    required int size,
    required String sort,
  });
}