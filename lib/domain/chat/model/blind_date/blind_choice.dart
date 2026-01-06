import 'package:freezed_annotation/freezed_annotation.dart';

part 'blind_choice.freezed.dart';
part 'blind_choice.g.dart';

@freezed
@JsonSerializable()
class BlindChoice with _$BlindChoice {
  final int choicerId;
  final int? targetId;

  BlindChoice({
    required this.choicerId,
    required this.targetId,
  });

  Map<String, dynamic> toJson() => _$BlindChoiceToJson(this);
}