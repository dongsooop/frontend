import 'package:freezed_annotation/freezed_annotation.dart';

part 'blind_join_info.freezed.dart';
part 'blind_join_info.g.dart';

@freezed
@JsonSerializable()
class BlindJoinInfo with _$BlindJoinInfo {
  final String name;
  final String state;
  final int? maxCount;

  BlindJoinInfo({
    required this.name,
    required this.state,
    this.maxCount,
  });

  factory BlindJoinInfo.fromJson(Map<String, dynamic> json) =>
      _$BlindJoinInfoFromJson(json);
}
