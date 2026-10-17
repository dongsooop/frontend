import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_message_context_response.freezed.dart';
part 'report_message_context_response.g.dart';

@freezed
@JsonSerializable()
class ReportMessageContextResponse with _$ReportMessageContextResponse {
  final int senderId;
  final String content;
  final DateTime sentAt;

  const ReportMessageContextResponse({
    required this.senderId,
    required this.content,
    required this.sentAt,
  });

  factory ReportMessageContextResponse.fromJson(Map<String, dynamic> json) =>
      _$ReportMessageContextResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReportMessageContextResponseToJson(this);
}
