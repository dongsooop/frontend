import 'package:dongsoop/core/utils/time_formatter.dart';
import 'package:dongsoop/domain/report/model/report_message_context_response.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_message_context.freezed.dart';
part 'report_message_context.g.dart';

@freezed
@JsonSerializable()
class ReportMessageContext with _$ReportMessageContext {
  final int senderId;
  final String content;
  final String sentAt;

  const ReportMessageContext({
    required this.senderId,
    required this.content,
    required this.sentAt,
  });

  factory ReportMessageContext.fromEntity(
    ReportMessageContextResponse entity,
  ) {
    return ReportMessageContext(
      senderId: entity.senderId,
      content: entity.content,
      sentAt: formatSanctionTime(entity.sentAt) ?? '',
    );
  }

  factory ReportMessageContext.fromJson(Map<String, dynamic> json) =>
      _$ReportMessageContextFromJson(json);

  Map<String, dynamic> toJson() => _$ReportMessageContextToJson(this);
}
