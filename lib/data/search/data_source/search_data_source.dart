import 'package:dongsoop/data/search/model/search_market_model.dart';
import 'package:dongsoop/data/search/model/search_notice_model.dart';
import 'package:dongsoop/data/search/model/search_recruit_model.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/search/enum/board_type.dart';

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
    required List<RecruitType> types,
    required String departmentName,
    required int size,
    required String sort,
  });

  Future<List<SearchMarketModel>> searchMarket({
    required int page,
    required String keyword,
    required List<MarketType> types,
    required int size,
    required String sort,
  });

  Future<List<String>> searchAuto({
    required String keyword,
    required SearchBoardType boardType,
  });

  Future<List<String>> searchPopular();
}