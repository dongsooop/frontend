// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blind_choice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlindChoice _$BlindChoiceFromJson(Map<String, dynamic> json) => BlindChoice(
      choicerId: (json['choicerId'] as num).toInt(),
      targetId: (json['targetId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BlindChoiceToJson(BlindChoice instance) =>
    <String, dynamic>{
      'choicerId': instance.choicerId,
      'targetId': instance.targetId,
    };
