class ChatbotState {
  final bool isLoading;
  final bool isEnabled;

  ChatbotState({
    required this.isLoading,
    required this.isEnabled,
  });

  ChatbotState copyWith({
    bool? isLoading,
    bool? isEnabled,
  }) {
    return ChatbotState(
      isLoading: isLoading ?? this.isLoading,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}