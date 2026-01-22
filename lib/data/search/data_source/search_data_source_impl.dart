import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/search/data_source/search_data_source.dart';
import 'package:dongsoop/data/search/data_source/auto_complete_mapper.dart';
import 'package:dongsoop/data/search/model/search_market_model.dart';
import 'package:dongsoop/data/search/model/search_notice_model.dart';
import 'package:dongsoop/data/search/model/search_recruit_model.dart';
import 'package:dongsoop/domain/board/market/enum/market_type.dart';
import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/search/enum/board_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchDataSourceImpl implements SearchDataSource {
  final Dio _plainDio;
  final Dio _authDio;

  SearchDataSourceImpl(this._plainDio, this._authDio);

  @override
  Future<List<SearchNoticeModel>> searchOfficialNotice({
    required int page,
    required String keyword,
    required int size,
    required String sort,
  }) async {
    final base = dotenv.get('SEARCH_TYPE_ENDPOINT');

    final params = {
      'page': page,
      'size': size,
      'sort': sort,
      if (keyword.trim().isNotEmpty) 'keyword': keyword.trim(),
      'boardType': 'NOTICE',
      'departmentName': '학교공지'
    };

    final response = await _plainDio.get(base, queryParameters: params);

    if (response.statusCode == HttpStatusCode.ok.code) {
      final list = response.data['results'] as List;
      return list.map((e) => SearchNoticeModel.fromJson(e)).toList();
    }
    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<List<SearchNoticeModel>> searchDeptNotice({
    required int page,
    required String keyword,
    required String departmentName,
    required int size,
    required String sort,
  }) async {
    final base = dotenv.get('NOTICE_SEARCH_ENDPOINT');

    final params = {
      'page': page,
      'size': size,
      'sort': sort,
      if (keyword.trim().isNotEmpty) 'keyword': keyword.trim(),
      'authorName': departmentName,
    };

    final response = await _plainDio.get(base, queryParameters: params);

    if (response.statusCode == HttpStatusCode.ok.code) {
      final list = response.data['results'] as List;
      return list.map((e) => SearchNoticeModel.fromJson(e)).toList();
    }
    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<List<SearchRecruitModel>> searchRecruit({
    required int page,
    required String keyword,
    required List<RecruitType> types,
    required String departmentName,
    required int size,
    required String sort,
  }) async {
    final base = dotenv.get('SEARCH_TYPE_ENDPOINT');

    final params = {
      'page': page,
      'size': size,
      'sort': sort,
      if (keyword.trim().isNotEmpty) 'keyword': keyword.trim(),
      'boardType': types.map((e) => e.name).toList(),
      if (departmentName.trim().isNotEmpty)
        'departmentName': departmentName.trim(),
    };

    final response = await _plainDio.get(
      base,
      queryParameters: params,
    );

    if (response.statusCode == HttpStatusCode.ok.code) {
      final list = response.data['results'] as List;
      return list.map((e) => SearchRecruitModel.fromJson(e)).toList();
    }

    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<List<SearchMarketModel>> searchMarket({
    required int page,
    required String keyword,
    required List<MarketType> types,
    required int size,
    required String sort,
  }) async {
    final base = dotenv.get('SEARCH_TYPE_ENDPOINT');

    final params = {
      'page': page,
      'size': size,
      'sort': sort,
      if (keyword.trim().isNotEmpty) 'keyword': keyword.trim(),
      'boardType': 'MARKETPLACE',
      'marketplaceType': types.map((e) => e.name).toList(),
    };

    final response = await _plainDio.get(
      base,
      queryParameters: params,
    );

    if (response.statusCode == HttpStatusCode.ok.code) {
      final list = response.data['results'] as List;
      return list.map((e) => SearchMarketModel.fromJson(e)).toList();
    }

    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<List<String>> searchAuto({
    required String keyword,
    required SearchBoardType boardType,
  }) async {
    final base = dotenv.get('AUTO_SEARCH_ENDPOINT');

    final params = {
      if (keyword.trim().isNotEmpty) 'keyword': keyword.trim(),
      'boardType': AutoCompleteMapper.toApiBoardType(boardType),
    };

    final response = await _authDio.get(base, queryParameters: params);

    if (response.statusCode == HttpStatusCode.ok.code) {
      return AutoCompleteMapper.parseKeywordList(response.data);
    }

    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<List<String>> searchPopular() async {
    final base = dotenv.get('POPULAR_SEARCH_ENDPOINT');
    final response = await _plainDio.get(base);

    if (response.statusCode == HttpStatusCode.ok.code) {
      return AutoCompleteMapper.parseKeywordList(response.data);
    }

    throw Exception('status: ${response.statusCode}');
  }
}
