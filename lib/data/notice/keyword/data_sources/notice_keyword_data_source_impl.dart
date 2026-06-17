import 'package:dio/dio.dart';
import 'package:dongsoop/domain/notice/keyword/entity/notice_keyword_entity.dart';
import 'package:dongsoop/domain/notice/keyword/enum/notice_keyword_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/notice/keyword/data_sources/notice_keyword_data_source.dart';

class NoticeKeywordDataSourceImpl implements NoticeKeywordDataSource {
  final Dio _authDio;

  NoticeKeywordDataSourceImpl(this._authDio);

  @override
  Future<List<NoticeKeywordEntity>> getKeywords() async {
    final endpoint = dotenv.get('NOTICE_KEYWORD_ENDPOINT');

    try {
      final response = await _authDio.get(endpoint);

      if (response.statusCode == HttpStatusCode.ok.code) {
        final list = response.data as List;
        return list.map((json) => NoticeKeywordEntity.fromJson(json)).toList();
      }

      throw Exception('status: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<NoticeKeywordEntity> addKeyword({
    required String keyword,
    required NoticeKeywordType type,
  }) async {
    final endpoint = dotenv.get('NOTICE_KEYWORD_ENDPOINT');
    final requestBody = {
      'keyword': keyword,
      'type': type.name.toUpperCase(),
    };

    try {
      final response = await _authDio.post(
        endpoint,
        data: requestBody,
      );

      if (response.statusCode == HttpStatusCode.created.code) {
        return NoticeKeywordEntity.fromJson(response.data);
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
