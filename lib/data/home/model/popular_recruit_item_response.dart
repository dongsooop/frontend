import 'package:freezed_annotation/freezed_annotation.dart';

part 'popular_recruit_item_response.freezed.dart';
part 'popular_recruit_item_response.g.dart';

@freezed
@JsonSerializable()
class PopularRecruitItemResponse with _$PopularRecruitItemResponse {
  final String title;
  final String content;
  final String tags;

  const PopularRecruitItemResponse({
    required this.title,
    required this.content,
    required this.tags,
  });

  factory PopularRecruitItemResponse.fromJson(Map<String, dynamic> json) => _$PopularRecruitItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PopularRecruitItemResponseToJson(this);
}