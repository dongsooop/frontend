import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_write_request.freezed.dart';
part 'report_write_request.g.dart';

@freezed
@JsonSerializable()
class ReportWriteRequest with _$ReportWriteRequest {
  final String reportType;
  final int targetId;
  final String reason;
  final String? description;

  const ReportWriteRequest({
    required this.reportType,
    required this.targetId,
    required this.reason,
    required this.description,
  });

  Map<String, dynamic> toJson() => _$ReportWriteRequestToJson(this);
}