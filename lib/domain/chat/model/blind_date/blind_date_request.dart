import 'package:freezed_annotation/freezed_annotation.dart';

part 'blind_date_request.freezed.dart';
part 'blind_date_request.g.dart';

@freezed
@JsonSerializable()
class BlindDateRequest with _$BlindDateRequest {
  final String sessionId;
  final String message;
  final int senderId;

  BlindDateRequest({
    required this.sessionId,
    required this.message,
    required this.senderId,
  });

  Map<String, dynamic> toJson() => _$BlindDateRequestToJson(this);
}