import 'package:dongsoop/domain/report/enum/report_reason.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_report_request.freezed.dart';
part 'chat_report_request.g.dart';

@freezed
@JsonSerializable(includeIfNull: false)
class ChatReportRequest with _$ChatReportRequest {
  final String roomId;
  final String messageId;
  final ReportReason reason;
  final String? description;

  const ChatReportRequest({
    required this.roomId,
    required this.messageId,
    required this.reason,
    this.description,
  });

  factory ChatReportRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatReportRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChatReportRequestToJson(this);
}
