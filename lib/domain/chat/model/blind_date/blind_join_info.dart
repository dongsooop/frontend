import 'package:freezed_annotation/freezed_annotation.dart';

part 'blind_join_info.freezed.dart';
part 'blind_join_info.g.dart';

@freezed
@JsonSerializable()
class BlindJoinInfo with _$BlindJoinInfo {
  final String sessionId;
  final String name;

  BlindJoinInfo({
    required this.sessionId,
    required this.name,
  });

  factory BlindJoinInfo.fromJson(Map<String, dynamic> json) => _$BlindJoinInfoFromJson(json);
}