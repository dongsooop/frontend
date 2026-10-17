class BlindResetState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const BlindResetState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });
}
