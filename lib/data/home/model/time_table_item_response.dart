import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_table_item_response.freezed.dart';
part 'time_table_item_response.g.dart';

@freezed
@JsonSerializable()
class TimeTableItemResponse with _$TimeTableItemResponse {
  final String title;
  final String startAt;
  final String endAt;

  const TimeTableItemResponse({
    required this.title,
    required this.startAt,
    required this.endAt,
  });

  factory TimeTableItemResponse.fromJson(Map<String, dynamic> json) => _$TimeTableItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TimeTableItemResponseToJson(this);
}