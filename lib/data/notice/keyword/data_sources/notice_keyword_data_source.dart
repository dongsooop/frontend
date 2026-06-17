import 'package:dongsoop/domain/notice/keyword/entity/notice_keyword_entity.dart';
import 'package:dongsoop/domain/notice/keyword/enum/notice_keyword_type.dart';

abstract class NoticeKeywordDataSource {
  Future<List<NoticeKeywordEntity>> getKeywords();
  Future<NoticeKeywordEntity> addKeyword({
    required String keyword,
    required NoticeKeywordType type,
  });
  Future<void> deleteKeyword(int keywordId);
}
