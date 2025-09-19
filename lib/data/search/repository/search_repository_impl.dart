import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/search/data_source/search_data_source.dart';
import 'package:dongsoop/data/search/model/search_market_model.dart';
import 'package:dongsoop/data/search/model/search_notice_model.dart';
import 'package:dongsoop/data/search/model/search_recruit_model.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/search/entity/search_market_entity.dart';
import 'package:dongsoop/domain/search/entity/search_notice_entity.dart';
import 'package:dongsoop/domain/search/entity/search_recruit_entity.dart';
import 'package:dongsoop/domain/search/repository/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchDataSource _dataSource;
  SearchRepositoryImpl(this._dataSource);

  @override
  Future<List<SearchNoticeEntity>> searchOfficialNotice({
    required int page,
    required String keyword,
    required int size,
    required String sort,
  }) async {
    return _handle(() async {
      final models = await _dataSource.searchOfficialNotice(
          page: page,
          keyword: keyword,
          size: size,
          sort: sort,
      );
      return models.map((m) => m.toEntity(isDepartment: false)).toList();
    }, SearchException());
  }

  @override
  Future<List<SearchNoticeEntity>> searchDeptNotice({
    required int page,
    required String keyword,
    required String departmentName,
    required int size,
    required String sort,
  }) async {
    return _handle(() async {
      final models = await _dataSource.searchDeptNotice(
          page: page,
          keyword: keyword,
          departmentName: departmentName,
          size: size,
          sort: sort,
      );
      return models.map((m) => m.toEntity(isDepartment: true)).toList();
    }, SearchException());
  }

  @override
  Future<List<SearchRecruitEntity>> searchRecruit({
    required int page,
    required String keyword,
    required RecruitType type,
    required String departmentName,
    required int size,
    required String sort,
  }) async {
    return _handle(() async {
      final models = await _dataSource.searchRecruit(
          page: page,
          keyword: keyword,
          type: type,
          departmentName: departmentName,
          size: size,
          sort: sort,
      );
      return models.map((model) => model.toEntity()).toList();
    }, SearchException());
  }

  @override
  Future<List<SearchMarketEntity>> searchMarket({
    required int page,
    required String keyword,
    required MarketType type,
    required int size,
    required String sort,
  }) async {
    return _handle(() async {
      final models = await _dataSource.searchMarket(
        page: page,
        keyword: keyword,
        type: type,
        size: size,
        sort: sort,
      );
      return models.map((model) => model.toEntity()).toList();
    }, SearchException());
  }

  Future<T> _handle<T>(Future<T> Function() action, Exception exception) async {
    try {
      return await action();
    } catch (_) {
      throw exception;
    }
  }
}