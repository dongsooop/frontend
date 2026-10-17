import 'package:dongsoop/domain/report/enum/sanction_type.dart';

enum ReportAdminSanctionFailure {
  validation,
  forbidden,
  notFound,
  alreadyProcessed,
  unknown,
}

class ReportAdminSanctionState {
  final SanctionType? sanctionType;
  final String sanctionReason;
  final DateTime? sanctionEndAt;
  final bool isSubmitting;
  final String? errorMessage;
  final ReportAdminSanctionFailure? failure;

  const ReportAdminSanctionState({
    this.sanctionType,
    this.sanctionReason = '',
    this.sanctionEndAt,
    this.isSubmitting = false,
    this.errorMessage,
    this.failure,
  });

  ReportAdminSanctionState copyWith({
    SanctionType? sanctionType,
    String? sanctionReason,
    DateTime? sanctionEndAt,
    bool? isSubmitting,
    String? errorMessage,
    ReportAdminSanctionFailure? failure,
    bool clearSanctionEndAt = false,
    bool clearError = false,
  }) {
    return ReportAdminSanctionState(
      sanctionType: sanctionType ?? this.sanctionType,
      sanctionReason: sanctionReason ?? this.sanctionReason,
      sanctionEndAt:
          clearSanctionEndAt ? null : sanctionEndAt ?? this.sanctionEndAt,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}
