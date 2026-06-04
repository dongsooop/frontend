import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_token_request.freezed.dart';
part 'device_token_request.g.dart';

@freezed
@JsonSerializable()
class DeviceTokenRequest with _$DeviceTokenRequest {
  final String deviceToken;
  final String type;

 DeviceTokenRequest({
    required this.deviceToken,
    required this.type,
  });

  factory DeviceTokenRequest.fromJson(Map<String, dynamic> json) => _$DeviceTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceTokenRequestToJson(this);
}
