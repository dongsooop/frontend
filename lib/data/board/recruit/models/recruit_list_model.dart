import 'package:dongsoop/domain/board/recruit/entities/recruit_list_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruit_list_model.freezed.dart';
part 'recruit_list_model.g.dart';

@freezed
@JsonSerializable()
class RecruitListModel with _$RecruitListModel {
  final int id;
  final int volunteer;
  final DateTime startAt;
  final DateTime endAt;
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

  factory RecruitListModel.fromJson(Map<String, dynamic> json) =>
      _$RecruitListModelFromJson(json);
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
      startAt: startAt,
      endAt: endAt,
      title: title,
      content: content,
      tags: tags,
      state: isActive,
    );
  }
}
