import 'package:dongsoop/domain/notice/entites/notice_entity.dart';

class NoticeModel {
  final int id;
  final String title;
  final String link;
  final String createdAt;

  NoticeModel({
    required this.id,
    required this.title,
    required this.link,
    required this.createdAt,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      link: json['link'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

extension NoticeModelMapper on NoticeModel {
  NoticeEntity toEntity({required bool isDepartment}) {
    return NoticeEntity(
      id: id,
      title: title,
      link: link,
      createdAt: DateTime.parse(createdAt),
      isDepartment: isDepartment,
    );
  }
}
