import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/notice/keyword/data_sources/notice_keyword_data_source.dart';
import 'package:dongsoop/data/notice/keyword/model/notice_keyword_model.dart';

class NoticeKeywordDataSourceImpl implements NoticeKeywordDataSource {
  final Dio _authDio;

  NoticeKeywordDataSourceImpl(this._authDio);

  @override
  Future<List<NoticeKeywordModel>> getKeywords() async {
    final response = await _authDio.get('/notice/keywords');

    if (response.statusCode == HttpStatusCode.ok.code) {
      final list = response.data as List;
      return list
          .map((json) => NoticeKeywordModel.fromJson(json))
          .toList();
    }
    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<NoticeKeywordModel> addKeyword({
    required String keyword,
    required String type,
  }) async {
    final response = await _authDio.post(
      '/notice/keywords',
      data: {'keyword': keyword, 'type': type},
    );

    if (response.statusCode == HttpStatusCode.created.code) {
      return NoticeKeywordModel.fromJson(response.data);
    }
    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<void> deleteKeyword(int keywordId) async {
    final response = await _authDio.delete('/notice/keywords/$keywordId');

    if (response.statusCode != HttpStatusCode.noContent.code) {
      throw Exception('status: ${response.statusCode}');
    }
  }
}
