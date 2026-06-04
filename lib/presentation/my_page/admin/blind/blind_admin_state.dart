class BlindAdminState {
  final bool isLoading;
  final String? errorMessage;
  final bool result;

  BlindAdminState({
    required this.isLoading,
    this.errorMessage,
    required this.result,
  });

  BlindAdminState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? result,
  }) {
    return BlindAdminState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      result: result ?? this.result,
    );
  }
}
