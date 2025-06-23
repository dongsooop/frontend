import 'package:dongsoop/domain/board/recruit/entities/recruit_detail_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruit_detail_model.freezed.dart';
part 'recruit_detail_model.g.dart';

@freezed
@JsonSerializable()
class RecruitDetailModel with _$RecruitDetailModel {
  final int id;
  final int volunteer;
  final DateTime startAt;
  final DateTime endAt;
  final String title;
  final String content;
  final String tags;
  final List<String> departmentTypeList;
  final String author;
  final DateTime createdAt;
  final String viewType;
  final bool isAlreadyApplied;

  RecruitDetailModel({
    required this.id,
    required this.volunteer,
    required this.startAt,
    required this.endAt,
    required this.title,
    required this.content,
    required this.tags,
    required this.departmentTypeList,
    required this.author,
    required this.createdAt,
    required this.viewType,
    required this.isAlreadyApplied,
  });

  factory RecruitDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RecruitDetailModelFromJson(json);
}

extension RecruitDetailModelMapper on RecruitDetailModel {
  RecruitDetailEntity toEntity() {
    return RecruitDetailEntity(
      id: id,
      volunteer: volunteer,
      startAt: startAt,
      endAt: endAt,
      title: title,
      content: content,
      tags: tags,
      departmentTypeList: departmentTypeList,
      author: author,
      createdAt: createdAt,
      viewType: viewType,
      isAlreadyApplied: isAlreadyApplied,
    );
  }
}
