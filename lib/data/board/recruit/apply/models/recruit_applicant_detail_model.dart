import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_detail_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruit_applicant_detail_model.freezed.dart';
part 'recruit_applicant_detail_model.g.dart';

@freezed
@JsonSerializable()
class RecruitApplicantDetailModel with _$RecruitApplicantDetailModel {
  final int boardId;
  final String title;
  final int applierId;
  final String applierName;
  final String departmentName;
  final String status;
  final DateTime applyTime;
  final String? introduction;
  final String? motivation;

  RecruitApplicantDetailModel({
    required this.boardId,
    required this.title,
    required this.applierId,
    required this.applierName,
    required this.departmentName,
    required this.status,
    required this.applyTime,
    this.introduction,
    this.motivation,
  });

  factory RecruitApplicantDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RecruitApplicantDetailModelFromJson(json);
}

extension RecruitApplicantDetailModelMapper on RecruitApplicantDetailModel {
  RecruitApplicantDetailEntity toEntity() {
    return RecruitApplicantDetailEntity(
      boardId: boardId,
      applierId: applierId,
      title: title,
      applierName: applierName,
      departmentName: departmentName,
      status: status,
      applyTime: applyTime,
      introduction: introduction,
      motivation: motivation,
    );
  }
}
