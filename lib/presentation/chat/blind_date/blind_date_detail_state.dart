class BlindDateDetailState {
  final bool isLoading;
  final String? errorMessage;
  final int participants;

  BlindDateDetailState({
    required this.isLoading,
    this.errorMessage,
    required this.participants
  });

  BlindDateDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    int? participants,
  }) {
    return BlindDateDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      participants: participants ?? this.participants,
    );
  }
}