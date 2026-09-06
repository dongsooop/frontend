import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_notice_item_response.freezed.dart';
part 'new_notice_item_response.g.dart';

@freezed
@JsonSerializable()
class NewNoticeItemResponse with _$NewNoticeItemResponse {
  /// 학교 공지 링크에서 뽑은 글 번호. 재크롤링해도 바뀌지 않아 읽음 기록의
  /// 키로 쓴다.
  ///
  /// 없을 수 있게 둔다. 이 필드를 넣기 전 서버가 아직 떠 있는 환경에서
  /// 필수로 두면 홈이 통째로 못 뜬다. 없으면 읽음 표시만 동작하지 않는다.
  final int? id;

  final String title;
  final String link;
  final String type;

  const NewNoticeItemResponse({
    this.id,
    required this.title,
    required this.link,
    required this.type,
  });

  factory NewNoticeItemResponse.fromJson(Map<String, dynamic> json) => _$NewNoticeItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NewNoticeItemResponseToJson(this);
}