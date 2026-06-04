class SignInState {
  final bool isLoading;
  final String? errorMessage;
  final String? dialogMessage;

  SignInState({
    required this.isLoading,
    this.errorMessage,
    this.dialogMessage,
  });

  SignInState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? dialogMessage,
  }) {
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      dialogMessage: dialogMessage,
    );
  }
}