enum ReportAdminDismissFailure {
  forbidden,
  notFound,
  alreadyProcessed,
  unknown,
}

class ReportAdminDismissState {
  final bool isSubmitting;
  final String? errorMessage;
  final ReportAdminDismissFailure? failure;

  const ReportAdminDismissState({
    this.isSubmitting = false,
    this.errorMessage,
    this.failure,
  });

  ReportAdminDismissState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    ReportAdminDismissFailure? failure,
    bool clearError = false,
  }) {
    return ReportAdminDismissState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}
