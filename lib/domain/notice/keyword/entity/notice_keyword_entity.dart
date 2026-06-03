import 'package:dongsoop/domain/notice/keyword/entity/notice_keyword_type.dart';

class NoticeKeywordEntity {
  final int id;
  final String keyword;
  final NoticeKeywordType type;

  const NoticeKeywordEntity({
    required this.id,
    required this.keyword,
    required this.type,
  });
}
