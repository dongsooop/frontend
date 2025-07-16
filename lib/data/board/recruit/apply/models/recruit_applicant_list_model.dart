import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_applicant_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruit_applicant_list_model.freezed.dart';
part 'recruit_applicant_list_model.g.dart';

@freezed
@JsonSerializable()
class RecruitApplicantListModel with _$RecruitApplicantListModel {
  final String memberName;
  final int memberId;
  final String departmentName;
  final String status;

  RecruitApplicantListModel({
    required this.memberName,
    required this.memberId,
    required this.departmentName,
    required this.status,
  });

  factory RecruitApplicantListModel.fromJson(Map<String, dynamic> json) =>
      _$RecruitApplicantListModelFromJson(json);
}

extension RecruitApplicantListModelMapper on RecruitApplicantListModel {
  RecruitApplicantListEntity toEntity() {
    return RecruitApplicantListEntity(
      memberName: memberName,
      memberId: memberId,
      departmentName: departmentName,
      status: status,
    );
  }
}
