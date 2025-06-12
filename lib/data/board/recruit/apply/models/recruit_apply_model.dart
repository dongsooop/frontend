import 'package:dongsoop/domain/board/recruit/apply/entity/recruit_apply_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruit_apply_model.freezed.dart';
part 'recruit_apply_model.g.dart';

@freezed
@JsonSerializable()
class RecruitApplyModel with _$RecruitApplyModel {
  final int boardId;
  final String introduction;
  final String motivation;

  RecruitApplyModel({
    required this.boardId,
    required this.introduction,
    required this.motivation,
  });

  Map<String, dynamic> toJson() => _$RecruitApplyModelToJson(this);

  factory RecruitApplyModel.fromEntity(RecruitApplyEntity entity) {
    return RecruitApplyModel(
      boardId: entity.boardId,
      introduction: entity.introduction,
      motivation: entity.motivation,
    );
  }
}
