import 'package:dongsoop/domain/board/recruit/entities/detail/recruit_detail_entity.dart';

class RecruitDetailModel {
  final int id;
  final int volunteer;
  final DateTime? startAt;
  final DateTime? endAt;
  final String title;
  final String content;
  final String tags;
  final List<String> departmentTypeList;
  final DateTime createdAt;

  RecruitDetailModel({
    required this.id,
    required this.volunteer,
    required this.startAt,
    required this.endAt,
    required this.title,
    required this.content,
    required this.tags,
    required this.departmentTypeList,
    required this.createdAt,
  });

  factory RecruitDetailModel.fromJson(Map<String, dynamic> json) {
    return RecruitDetailModel(
      id: json['id'] ?? 0,
      volunteer: json['volunteer'] ?? 0,
      startAt: json['startAt'] != null ? DateTime.parse(json['startAt']) : null,
      endAt: json['endAt'] != null ? DateTime.parse(json['endAt']) : null,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      tags: json['tags'] ?? '',
      departmentTypeList: (json['departmentTypeList'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

extension RecruitDetailModelMapper on RecruitDetailModel {
  RecruitDetailEntity toEntity() {
    final now = DateTime.now();

    final bool isActive = startAt != null && endAt != null
        ? !now.isBefore(startAt!) && now.isBefore(endAt!)
        : false;

    return RecruitDetailEntity(
      id: id,
      volunteer: volunteer,
      startAt: startAt ?? DateTime.now(),
      endAt: endAt ?? DateTime.now(),
      title: title,
      content: content,
      tags: tags,
      departmentTypeList: departmentTypeList,
      createdAt: createdAt,
      state: isActive,
    );
  }
}
