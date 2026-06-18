import 'package:dongsoop/domain/notice/keyword/repository/notice_keyword_repository.dart';

class DeleteNoticeKeywordUseCase {
  final NoticeKeywordRepository _repository;

  DeleteNoticeKeywordUseCase(this._repository);

  Future<void> execute(int keywordId) {
    return _repository.deleteKeyword(keywordId);
  }
}
