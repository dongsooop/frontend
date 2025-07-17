import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruit_decision_model.freezed.dart';
part 'recruit_decision_model.g.dart';

@freezed
@JsonSerializable()
class RecruitDecisionModel with _$RecruitDecisionModel {
  final String status;
  final int applierId;

  RecruitDecisionModel({
    required this.status,
    required this.applierId,
  });

  Map<String, dynamic> toJson() => _$RecruitDecisionModelToJson(this);
}
