import 'package:dongsoop/domain/notice/keyword/entity/notice_keyword_entity.dart';
import 'package:dongsoop/domain/notice/keyword/repository/notice_keyword_repository.dart';

class GetNoticeKeywordsUseCase {
  final NoticeKeywordRepository _repository;

  GetNoticeKeywordsUseCase(this._repository);

  Future<List<NoticeKeywordEntity>> execute() {
    return _repository.getKeywords();
  }
}
