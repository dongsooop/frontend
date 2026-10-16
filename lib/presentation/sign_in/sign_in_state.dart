class SignInState {
  final bool isLoading;
  final String? errorMessage;
  final String? dialogTitle;
  final String? dialogMessage;

  SignInState({
    required this.isLoading,
    this.errorMessage,
    this.dialogTitle,
    this.dialogMessage,
  });

  SignInState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? dialogTitle,
    String? dialogMessage,
  }) {
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      dialogTitle: dialogTitle,
      dialogMessage: dialogMessage,
    );
  }
}
