class ReportAdminSanctionState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccessed;

  ReportAdminSanctionState({
    required this.isLoading,
    this.errorMessage,
    required this.isSuccessed,
  });

  ReportAdminSanctionState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccessed,
  }) {
    return ReportAdminSanctionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccessed: isSuccessed ?? this.isSuccessed,
    );
  }
}