import 'package:dongsoop/domain/notice/keyword/entity/notice_keyword_entity.dart';
import 'package:dongsoop/domain/notice/keyword/entity/notice_keyword_type.dart';

class NoticeKeywordModel {
  final int id;
  final String keyword;
  final String type;

  const NoticeKeywordModel({
    required this.id,
    required this.keyword,
    required this.type,
  });

  factory NoticeKeywordModel.fromJson(Map<String, dynamic> json) {
    return NoticeKeywordModel(
      id: json['id'] as int,
      keyword: json['keyword'] as String,
      type: json['type'] as String,
    );
  }

  NoticeKeywordEntity toEntity() {
    return NoticeKeywordEntity(
      id: id,
      keyword: keyword,
      type: NoticeKeywordType.fromJson(type),
    );
  }
}
