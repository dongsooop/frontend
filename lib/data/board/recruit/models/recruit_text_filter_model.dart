import 'package:dongsoop/domain/board/recruit/entities/recruit_text_filter_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruit_text_filter_model.freezed.dart';
part 'recruit_text_filter_model.g.dart';

@freezed
@JsonSerializable()
class RecruitTextFilterModel with _$RecruitTextFilterModel {
  final String text;

  RecruitTextFilterModel({
    required this.text,
  });

  Map<String, dynamic> toJson() => _$RecruitTextFilterModelToJson(this);

  factory RecruitTextFilterModel.fromEntity(RecruitTextFilterEntity entity) {
    return RecruitTextFilterModel(
        text: '${entity.title} | ${entity.tags} | ${entity.content}');
  }
}
