import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';

class RecruitListModel {
  final int id;
  final int volunteer;
  final DateTime? startAt;
  final DateTime? endAt;
  final String title;
  final String content;
  final String tags;

  RecruitListModel({
    required this.id,
    required this.volunteer,
    required this.startAt,
    required this.endAt,
    required this.title,
    required this.content,
    required this.tags,
  });

  factory RecruitListModel.fromJson(Map<String, dynamic> json) {
    return RecruitListModel(
      id: json['id'] ?? 0,
      volunteer: json['volunteer'] ?? 0,
      startAt: json['startAt'] != null ? DateTime.parse(json['startAt']) : null,
      endAt: json['endAt'] != null ? DateTime.parse(json['endAt']) : null,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      tags: json['tags'] ?? '',
    );
  }
}

extension RecruitListModelMapper on RecruitListModel {
  RecruitListEntity toEntity() {
    final now = DateTime.now();

    final bool isActive = startAt != null && endAt != null
        ? !now.isBefore(startAt!) && now.isBefore(endAt!)
        : false;

    return RecruitListEntity(
      id: id,
      volunteer: volunteer,
      startAt: startAt ?? DateTime.now(),
      endAt: endAt ?? DateTime.now(),
      title: title,
      content: content,
      tags: tags,
      state: isActive,
    );
  }
}
