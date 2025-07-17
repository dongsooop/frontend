import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_sanction_response.freezed.dart';
part 'report_sanction_response.g.dart';

@freezed
@JsonSerializable()
class ReportSanctionResponse with _$ReportSanctionResponse {
  final bool isSanctioned;
  final String? sanctionType;
  final String? reason;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? description;

  const ReportSanctionResponse({
    required this.isSanctioned,
    this.sanctionType,
    this.reason,
    this.startDate,
    this.endDate,
    this.description,
  });

  Map<String, dynamic> toJson() => _$ReportSanctionResponseToJson(this);
  factory ReportSanctionResponse.fromJson(Map<String, dynamic> json) => _$ReportSanctionResponseFromJson(json);
}