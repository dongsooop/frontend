class ReportState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSelected;

  ReportState({
    required this.isLoading,
    this.errorMessage,
    required this.isSelected,
  });

  ReportState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSelected,
  }) {
   return ReportState(
    isLoading: isLoading ?? this.isLoading,
    errorMessage: errorMessage,
    isSelected: isSelected ?? this.isSelected,
   );
  }
}