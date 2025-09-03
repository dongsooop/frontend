class ChatbotState {
  final bool isLoading;

  ChatbotState({
    required this.isLoading,
  });

  ChatbotState copyWith({
    bool? isLoading,
  }) {
    return ChatbotState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}