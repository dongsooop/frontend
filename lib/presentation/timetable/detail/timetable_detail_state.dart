class TimetableDetailState {
  final bool isLoading;
  final String? errorMessage;

  TimetableDetailState({
    required this.isLoading,
    this.errorMessage,
  });

  TimetableDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return TimetableDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}