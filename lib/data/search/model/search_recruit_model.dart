import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/search/entity/search_recruit_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_recruit_model.freezed.dart';
part 'search_recruit_model.g.dart';

@freezed
@JsonSerializable()
class SearchRecruitModel with _$SearchRecruitModel {
  final int boardId;
  final String title;
  final String content;
  final RecruitType boardType;
  final DateTime createdAt;
  final int contactCount;
  final DateTime recruitmentStartAt;
  final DateTime recruitmentEndAt;
  final String tags;
  final String departmentName;

  SearchRecruitModel({
    required this.boardId,
    required this.title,
    required this.content,
    required this.boardType,
    required this.createdAt,
    required this.contactCount,
    required this.recruitmentStartAt,
    required this.recruitmentEndAt,
    required this.tags,
    required this.departmentName,
  });

  factory SearchRecruitModel.fromJson(Map<String, dynamic> json) => _$SearchRecruitModelFromJson(json);
}

extension SearchRecruitModelMapper on SearchRecruitModel {
  SearchRecruitEntity toEntity() {
    return SearchRecruitEntity(
      id: boardId,
      title: title,
      content: content,
      boardType: boardType,
      createdAt: createdAt,
      volunteer: contactCount,
      startAt: recruitmentStartAt,
      endAt: recruitmentEndAt,
      tags: _sanitizeTags(tags),
      departmentName: departmentName,
    );
  }
}

String _sanitizeTags(String raw) {
  if (raw.trim().isEmpty) return '';
  const blocked = {
    '_tagsparsefailure',
    '_dateparsefailure',
  };

  final tokens = raw
      .split(',')
      .map((t) => t.trim())
      .where((t) => t.isNotEmpty)
      .where((t) => !blocked.contains(t.toLowerCase()))
      .toList();

  return tokens.join(',');
}