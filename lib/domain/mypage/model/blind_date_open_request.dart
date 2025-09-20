import 'package:freezed_annotation/freezed_annotation.dart';

part 'blind_date_open_request.freezed.dart';
part 'blind_date_open_request.g.dart';

@freezed
@JsonSerializable()
class BlindDateOpenRequest with _$BlindDateOpenRequest {
  final DateTime expiredDate;
  final int maxSessionMemberCount;

  const BlindDateOpenRequest({
    required this.expiredDate,
    required this.maxSessionMemberCount,
  });

  Map<String, dynamic> toJson() => _$BlindDateOpenRequestToJson(this);
}