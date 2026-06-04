import 'package:freezed_annotation/freezed_annotation.dart';

part 'popular_recruit_item_response.freezed.dart';
part 'popular_recruit_item_response.g.dart';

@freezed
@JsonSerializable()
class PopularRecruitItemResponse with _$PopularRecruitItemResponse {
  final int id;
  final String title;
  final String content;
  final String tags;
  final int volunteer;
  final String type;

  const PopularRecruitItemResponse({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.volunteer,
    required this.type,
  });

  factory PopularRecruitItemResponse.fromJson(Map<String, dynamic> json) => _$PopularRecruitItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PopularRecruitItemResponseToJson(this);
}