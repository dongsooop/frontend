import 'package:freezed_annotation/freezed_annotation.dart';

part 'blind_join_info.freezed.dart';
part 'blind_join_info.g.dart';

@freezed
@JsonSerializable()
class BlindJoinInfo with _$BlindJoinInfo {
  final String name;
  final String state;

  BlindJoinInfo({
    required this.name,
    required this.state
  });

  factory BlindJoinInfo.fromJson(Map<String, dynamic> json) => _$BlindJoinInfoFromJson(json);
}