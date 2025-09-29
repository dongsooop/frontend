import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';

class SearchRecruitEntity {
  final int id;
  final String title;
  final String content;
  final RecruitType boardType;
  final DateTime createdAt;
  final int volunteer;
  final DateTime startAt;
  final DateTime endAt;
  final String tags;
  final String departmentName;

  const SearchRecruitEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.boardType,
    required this.createdAt,
    required this.volunteer,
    required this.startAt,
    required this.endAt,
    required this.tags,
    required this.departmentName,
  });
}