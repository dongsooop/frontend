import 'package:dongsoop/data/notice/keyword/model/notice_keyword_model.dart';

abstract class NoticeKeywordDataSource {
  Future<List<NoticeKeywordModel>> getKeywords();
  Future<NoticeKeywordModel> addKeyword({
    required String keyword,
    required String type,
  });
  Future<void> deleteKeyword(int keywordId);
}
