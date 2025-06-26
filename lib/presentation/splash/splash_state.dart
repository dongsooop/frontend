class SplashState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccessed;

  SplashState({
    required this.isLoading,
    this.errorMessage,
    required this.isSuccessed,
  });

  SplashState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccessed,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccessed: isSuccessed ?? this.isSuccessed,
    );
  }
}
