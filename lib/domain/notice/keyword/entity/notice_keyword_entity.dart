import 'package:dongsoop/domain/notice/keyword/enum/notice_keyword_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_keyword_entity.freezed.dart';
part 'notice_keyword_entity.g.dart';

@freezed
@JsonSerializable()
class NoticeKeywordEntity with _$NoticeKeywordEntity {
  final int id;
  final String keyword;
  final NoticeKeywordType type;

  const NoticeKeywordEntity({
    required this.id,
    required this.keyword,
    required this.type,
  });

  Map<String, dynamic> toJson() => _$NoticeKeywordEntityToJson(this);
  factory NoticeKeywordEntity.fromJson(Map<String, dynamic> json) => _$NoticeKeywordEntityFromJson(json);
}
