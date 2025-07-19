import 'package:freezed_annotation/freezed_annotation.dart';
import '../../board/recruit/enum/recruit_type.dart';

part 'mypage_recruit.freezed.dart';
part 'mypage_recruit.g.dart';

@freezed
@JsonSerializable()
class MypageRecruit with _$MypageRecruit {
  final int id;
  final String title;
  final String content;
  @JsonKey(fromJson: _parseToList)
  final List<String> tags;
  @JsonKey(fromJson: _parseToList)
  final List<String> departmentTypeList;
  @JsonKey(fromJson: _recruitTypeFromJson)
  final RecruitType boardType;
  final DateTime startAt;
  final DateTime endAt;
  final DateTime createdAt;
  final int volunteer;
  final bool isRecruiting;

  const MypageRecruit({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.departmentTypeList,
    required this.boardType,
    required this.startAt,
    required this.endAt,
    required this.createdAt,
    required this.volunteer,
    required this.isRecruiting,
  });

  Map<String, dynamic> toJson() => _$MypageRecruitToJson(this);
  factory MypageRecruit.fromJson(Map<String, dynamic> json) => _$MypageRecruitFromJson(json);
}

List<String> _parseToList(dynamic value) {
  if (value == null) return [];
  if (value is String) {
    if (value.trim().isEmpty) return [];
    return value.split(',').map((e) => e.trim()).toList();
  }
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  return [];
}

RecruitType _recruitTypeFromJson(String value) {
  switch (value) {
    case 'TUTORING':
      return RecruitType.tutoring;
    case 'STUDY':
      return RecruitType.study;
    case 'PROJECT':
      return RecruitType.project;
    default:
      throw ArgumentError('Unknown RecruitType: $value');
  }
}