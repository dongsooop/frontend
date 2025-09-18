class BlindDateState {
  final bool isLoading;
  final String? errorMessage;
  final String? isBlindDateOpened;

  BlindDateState({
    required this.isLoading,
    this.errorMessage,
    this.isBlindDateOpened,
  });

  BlindDateState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? isBlindDateOpened,
  }) {
    return BlindDateState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isBlindDateOpened: isBlindDateOpened,
    );
  }
}
