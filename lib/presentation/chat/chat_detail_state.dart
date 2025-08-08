class ChatDetailState {
  final bool isLoading;
  final String? errorMessage;
  final Map<String, String> nicknameMap;
  final int? otherUserId;

  ChatDetailState({
    required this.isLoading,
    this.errorMessage,
    this.nicknameMap = const {},
    this.otherUserId,
  });

  ChatDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    Map<String, String>? nicknameMap,
    int? otherUserId,
  }) {
    return ChatDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      nicknameMap: nicknameMap ?? this.nicknameMap,
      otherUserId: otherUserId ?? this.otherUserId
    );
  }
}
