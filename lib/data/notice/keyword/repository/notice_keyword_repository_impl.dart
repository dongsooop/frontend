import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/notice/keyword/data_sources/notice_keyword_data_source.dart';
import 'package:dongsoop/domain/notice/keyword/entity/notice_keyword_entity.dart';
import 'package:dongsoop/domain/notice/keyword/enum/notice_keyword_type.dart';
import 'package:dongsoop/domain/notice/keyword/repository/notice_keyword_repository.dart';

class NoticeKeywordRepositoryImpl implements NoticeKeywordRepository {
  final NoticeKeywordDataSource _dataSource;

  NoticeKeywordRepositoryImpl(this._dataSource);

  @override
  Future<List<NoticeKeywordEntity>> getKeywords() async {
    try {
      return await _dataSource.getKeywords();
    } catch (_) {
      throw NoticeKeywordException();
    }
  }

  @override
  Future<NoticeKeywordEntity> addKeyword({
    required String keyword,
    required NoticeKeywordType type,
  }) async {
    try {
      return await _dataSource.addKeyword(
        keyword: keyword,
        type: type,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.conflict.code) {
        throw DuplicateNoticeKeywordException();
      }
      throw NoticeKeywordException();
    } catch (_) {
      throw NoticeKeywordException();
    }
  }

  @override
  Future<void> deleteKeyword(int keywordId) async {
    try {
      await _dataSource.deleteKeyword(keywordId);
    } catch (_) {
      throw NoticeKeywordException();
    }
  }
}
