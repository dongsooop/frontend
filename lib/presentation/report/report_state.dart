class ReportState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccessed;

  ReportState({
    required this.isLoading,
    this.errorMessage,
    required this.isSuccessed,
  });

  ReportState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccessed,
  }) {
   return ReportState(
     isLoading: isLoading ?? this.isLoading,
     errorMessage: errorMessage,
     isSuccessed: isSuccessed ?? this.isSuccessed,
   );
  }
}