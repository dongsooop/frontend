import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/notice/keyword/data_sources/notice_keyword_data_source.dart';
import 'package:dongsoop/data/notice/keyword/model/notice_keyword_model.dart';

class NoticeKeywordDataSourceImpl implements NoticeKeywordDataSource {
  final Dio _authDio;

  NoticeKeywordDataSourceImpl(this._authDio);

  @override
  Future<List<NoticeKeywordModel>> getKeywords() async {
    final endpoint = dotenv.get('NOTICE_KEYWORD_ENDPOINT');

    try {
      final response = await _authDio.get(endpoint);

      if (response.statusCode == HttpStatusCode.ok.code) {
        final list = response.data as List;
        return list.map((json) => NoticeKeywordModel.fromJson(json)).toList();
      }

      throw Exception('status: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<NoticeKeywordModel> addKeyword({
    required String keyword,
    required String type,
  }) async {
    final endpoint = dotenv.get('NOTICE_KEYWORD_ENDPOINT');
    final requestBody = {
      'keyword': keyword,
      'type': type
    };

    try {
      final response = await _authDio.post(
        endpoint,
        data: requestBody,
      );

      if (response.statusCode == HttpStatusCode.created.code) {
        return NoticeKeywordModel.fromJson(response.data);
      }

      throw Exception('status: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteKeyword(int keywordId) async {
    final notice = dotenv.get('NOTICE_KEYWORD_ENDPOINT');
    final endpoint = notice + '/$keywordId';

    try {
      final response = await _authDio.delete(endpoint);

      if (response.statusCode != HttpStatusCode.noContent.code) {
        throw Exception('status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
