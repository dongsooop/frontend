import 'package:dongsoop/domain/notice/entity/notice_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_model.freezed.dart';
part 'notice_model.g.dart';

@freezed
@JsonSerializable()
class NoticeModel with _$NoticeModel {
  final int id;
  final String title;
  final String link;
  final DateTime createdAt;

  NoticeModel({
    required this.id,
    required this.title,
    required this.link,
    required this.createdAt,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);
}

extension NoticeModelMapper on NoticeModel {
  NoticeEntity toEntity({required bool isDepartment}) {
    return NoticeEntity(
      id: id,
      title: title,
      link: link,
      createdAt: createdAt,
      isDepartment: isDepartment,
    );
  }
}
