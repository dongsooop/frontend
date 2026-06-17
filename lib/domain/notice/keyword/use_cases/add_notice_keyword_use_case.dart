import 'package:dongsoop/domain/notice/keyword/entity/notice_keyword_entity.dart';
import 'package:dongsoop/domain/notice/keyword/enum/notice_keyword_type.dart';
import 'package:dongsoop/domain/notice/keyword/repository/notice_keyword_repository.dart';

class AddNoticeKeywordUseCase {
  final NoticeKeywordRepository _repository;

  AddNoticeKeywordUseCase(this._repository);

  Future<NoticeKeywordEntity> execute({
    required String keyword,
    required NoticeKeywordType type,
  }) {
    return _repository.addKeyword(keyword: keyword, type: type);
  }
}
