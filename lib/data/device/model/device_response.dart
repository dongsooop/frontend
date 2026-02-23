import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_response.freezed.dart';
part 'device_response.g.dart';

@freezed
@JsonSerializable()
class DeviceResponse with _$DeviceResponse{
  final int id;
  final String type;

  DeviceResponse({
    required this.id,
    required this.type,
  });

  factory DeviceResponse.fromJson(Map<String, dynamic> json) => _$DeviceResponseFromJson(json);
}