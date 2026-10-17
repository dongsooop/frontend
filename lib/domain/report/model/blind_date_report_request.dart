import 'package:dongsoop/domain/report/enum/report_reason.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'blind_date_report_request.freezed.dart';
part 'blind_date_report_request.g.dart';

@freezed
@JsonSerializable(includeIfNull: false)
class BlindDateReportRequest with _$BlindDateReportRequest {
  final String sessionId;
  final String messageId;
  final ReportReason reason;
  final String? description;

  const BlindDateReportRequest({
    required this.sessionId,
    required this.messageId,
    required this.reason,
    this.description,
  });

  factory BlindDateReportRequest.fromJson(Map<String, dynamic> json) =>
      _$BlindDateReportRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BlindDateReportRequestToJson(this);
}
