import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_notice_item_response.freezed.dart';
part 'new_notice_item_response.g.dart';

@freezed
@JsonSerializable()
class NewNoticeItemResponse with _$NewNoticeItemResponse {
  final String title;
  final String link;
  final String type;

  const NewNoticeItemResponse({
    required this.title,
    required this.link,
    required this.type,
  });

  factory NewNoticeItemResponse.fromJson(Map<String, dynamic> json) => _$NewNoticeItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NewNoticeItemResponseToJson(this);
}