class SettingState {
  final bool isLoading;
  final String? errorMessage;

  SettingState({
    required this.isLoading,
    this.errorMessage,
  });

  SettingState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return SettingState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
