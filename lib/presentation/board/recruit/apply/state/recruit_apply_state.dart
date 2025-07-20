class RecruitApplyState {
  final bool isLoading;
  final String? profanityMessage;
  final int profanityMessageTriggerKey;

  const RecruitApplyState({
    this.isLoading = false,
    this.profanityMessage,
    this.profanityMessageTriggerKey = 0,
  });

  RecruitApplyState copyWith({
    bool? isLoading,
    String? profanityMessage,
    int? profanityMessageTriggerKey,
  }) {
    return RecruitApplyState(
      isLoading: isLoading ?? this.isLoading,
      profanityMessage: profanityMessage,
      profanityMessageTriggerKey:
          profanityMessageTriggerKey ?? this.profanityMessageTriggerKey,
    );
  }
}
