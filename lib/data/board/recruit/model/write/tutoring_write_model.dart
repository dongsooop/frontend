import 'package:dongsoop/domain/board/recruit/entities/write/tutoring_write_entity.dart';

class TutoringWriteModel {
  final String title;
  final String content;
  final String tags;
  final DateTime startAt;
  final DateTime endAt;
  final String departmentType;

  TutoringWriteModel({
    required this.title,
    required this.content,
    required this.tags,
    required this.startAt,
    required this.endAt,
    required this.departmentType,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'tags': tags,
        'startAt': startAt.toIso8601String(),
        'endAt': endAt.toIso8601String(),
        'departmentType': departmentType,
      };

  factory TutoringWriteModel.fromEntity(TutoringWriteEntity entity) {
    return TutoringWriteModel(
      title: entity.title,
      content: entity.content,
      tags: entity.tags,
      startAt: entity.startAt,
      endAt: entity.endAt,
      departmentType: entity.departmentType,
    );
  }
}
