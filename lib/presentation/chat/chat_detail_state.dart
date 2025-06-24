class ChatDetailState {
  final bool isLoading;
  final String? errorMessage;
  final Map<String, String> nicknameMap;

  ChatDetailState({
    required this.isLoading,
    this.errorMessage,
    this.nicknameMap = const {},
  });

  ChatDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    Map<String, String>? nicknameMap,
  }) {
    return ChatDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      nicknameMap: nicknameMap ?? this.nicknameMap,
    );
  }
}
