import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/search/data_source/search_data_source.dart';
import 'package:dongsoop/data/search/data_source/auto_complete_mapper.dart';
import 'package:dongsoop/data/search/model/search_notice_model.dart';

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
    final base = '/search/by-type';

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
    final base = '/search/department-notice';

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
  Future<List<String>> searchAuto({
    required String keyword,
  }) async {
    final base = '/search/autocomplete';

    final params = {
      if (keyword.trim().isNotEmpty) 'keyword': keyword.trim(),
      'boardType': 'NOTICE',
    };

    final response = await _authDio.get(base, queryParameters: params);

    if (response.statusCode == HttpStatusCode.ok.code) {
      return AutoCompleteMapper.parseKeywordList(response.data);
    }

    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<List<String>> searchPopular() async {
    final base = '/search/popular';
    final response = await _plainDio.get(base);

    if (response.statusCode == HttpStatusCode.ok.code) {
      return AutoCompleteMapper.parseKeywordList(response.data);
    }

    throw Exception('status: ${response.statusCode}');
  }
}
