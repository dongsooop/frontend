import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_item_response.freezed.dart';
part 'schedule_item_response.g.dart';

@freezed
@JsonSerializable()
class ScheduleItemResponse with _$ScheduleItemResponse {
  final String title;
  final String startAt;
  final String endAt;
  final String type;

  const ScheduleItemResponse({
    required this.title,
    required this.startAt,
    required this.endAt,
    required this.type,
  });

  factory ScheduleItemResponse.fromJson(Map<String, dynamic> json) => _$ScheduleItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleItemResponseToJson(this);
}