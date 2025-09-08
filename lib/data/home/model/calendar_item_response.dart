import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_item_response.freezed.dart';
part 'calendar_item_response.g.dart';

@freezed
@JsonSerializable()
class CalendarItemResponse with _$CalendarItemResponse {
  final String title;
  final String startAt;
  final String endAt;

  const CalendarItemResponse({
    required this.title,
    required this.startAt,
    required this.endAt,
  });

  factory CalendarItemResponse.fromJson(Map<String, dynamic> json) => _$CalendarItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarItemResponseToJson(this);
}