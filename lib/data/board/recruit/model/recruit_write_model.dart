import 'package:dongsoop/domain/board/recruit/entities/recruit_write_entity.dart';

class RecruitWriteModel {
  final String title;
  final String content;
  final String tags;
  final DateTime startAt;
  final DateTime endAt;
  final List<String> departmentTypeList;

  RecruitWriteModel({
    required this.title,
    required this.content,
    required this.tags,
    required this.startAt,
    required this.endAt,
    required this.departmentTypeList,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'tags': tags,
        'startAt': startAt.toIso8601String(),
        'endAt': endAt.toIso8601String(),
        'departmentTypeList': departmentTypeList,
      };

  factory RecruitWriteModel.fromEntity(RecruitWriteEntity entity) {
    return RecruitWriteModel(
      title: entity.title,
      content: entity.content,
      tags: entity.tags,
      startAt: entity.startAt,
      endAt: entity.endAt,
      departmentTypeList: entity.departmentTypeList,
    );
  }
}
