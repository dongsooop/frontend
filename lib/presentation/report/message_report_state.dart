import 'package:dongsoop/domain/report/enum/report_reason.dart';

class MessageReportState {
  final ReportReason? selectedReason;
  final String description;
  final bool isSubmitting;
  final String? errorMessage;

  const MessageReportState({
    this.selectedReason,
    this.description = '',
    this.isSubmitting = false,
    this.errorMessage,
  });

  bool get canSubmit =>
      selectedReason != null && description.length <= 500 && !isSubmitting;

  MessageReportState copyWith({
    ReportReason? selectedReason,
    String? description,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MessageReportState(
      selectedReason: selectedReason ?? this.selectedReason,
      description: description ?? this.description,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
