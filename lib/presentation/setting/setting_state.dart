class SettingState {
  final bool isLoading;
  final String? errorMessage;
  final String? errorTitle;

  SettingState({
    required this.isLoading,
    this.errorMessage,
    this.errorTitle,
  });

  SettingState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? errorTitle,
  }) {
    return SettingState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      errorTitle: errorTitle
    );
  }
}
