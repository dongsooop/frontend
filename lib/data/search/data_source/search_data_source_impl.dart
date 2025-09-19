import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/search/data_source/search_data_source.dart';
import 'package:dongsoop/data/search/model/search_notice_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchDataSourceImpl implements SearchDataSource {
  final Dio _plainDio;
  SearchDataSourceImpl(this._plainDio);

  @override
  Future<List<SearchNoticeModel>> searchOfficialNotice({
    required int page,
    required String keyword,
    String sort = 'createdAt,desc',
    int size = 20,
  }) async {
    final base = dotenv.get('SEARCH_TYPE_ENDPOINT');

    final params = <String, dynamic>{
      'page': page,
      'size': size,
      'sort': sort,
      if (keyword.trim().isNotEmpty) 'keyword': keyword.trim(),
      'boardType': 'NOTICE',
      'departmentName': '학교공지'
    };

    final response = await _plainDio.get(base, queryParameters: params);

    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! Map || data['results'] is! List) {
        throw const FormatException('응답 데이터 형식이 옳지 않습니다.');
      }
      final list = data['results'] as List;
      return list.map((json) => SearchNoticeModel.fromJson(json)).toList();
    }
    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<List<SearchNoticeModel>> searchDeptNotice({
    required int page,
    required String keyword,
    required String departmentName,
    String sort = 'createdAt,desc',
    int size = 20,
  }) async {
    final base = dotenv.get('NOTICE_SEARCH_ENDPOINT');

    final params = <String, dynamic>{
      'page': page,
      'size': size,
      'sort': sort,
      if (keyword.trim().isNotEmpty) 'keyword': keyword.trim(),
      'authorName': departmentName,
    };

    final response = await _plainDio.get(base, queryParameters: params);

    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! Map || data['results'] is! List) {
        throw const FormatException('응답 데이터 형식이 옳지 않습니다.');
      }
      final list = data['results'] as List;
      return list.map((json) => SearchNoticeModel.fromJson(json)).toList();
    }
    throw Exception('status: ${response.statusCode}');
  }
}
