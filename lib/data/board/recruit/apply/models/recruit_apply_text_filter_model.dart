import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_text_filter_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruit_apply_text_filter_model.freezed.dart';
part 'recruit_apply_text_filter_model.g.dart';

@freezed
@JsonSerializable()
class RecruitApplyTextFilterModel with _$RecruitApplyTextFilterModel {
  final String text;

  RecruitApplyTextFilterModel({
    required this.text,
  });

  Map<String, dynamic> toJson() => _$RecruitApplyTextFilterModelToJson(this);

  factory RecruitApplyTextFilterModel.fromEntity(
      RecruitApplyTextFilterEntity entity) {
    return RecruitApplyTextFilterModel(
        text: '${entity.introduction} | ${entity.motivation}');
  }
}
