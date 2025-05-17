import 'package:dongsoop/domain/board/recruit/entities/write/tutoring_write_entity.dart';

class TutoringWriteModel {
  final String title;
  final String content;
  final String tags;
  final int recruitmentCapacity;
  final DateTime startAt;
  final DateTime endAt;
  final String departmentType;

  TutoringWriteModel({
    required this.title,
    required this.content,
    required this.tags,
    required this.recruitmentCapacity,
    required this.startAt,
    required this.endAt,
    required this.departmentType,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'tags': tags,
      'recruitmentCapacity': recruitmentCapacity,
      'startAt': startAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
      'departmentType': departmentType,
    };
  }
}

extension TutoringMapper on TutoringWriteModel {
  TutoringWriteEntity toEntity() {
    return TutoringWriteEntity(
        title: title,
        content: content,
        tags: tags,
        recruitmentCapacity: recruitmentCapacity,
        startAt: startAt,
        endAt: endAt,
        departmentType: departmentType);
  }
}
