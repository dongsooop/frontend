class RecruitApplyState {
  final bool isLoading;
  final String? profanityMessage;
  final int profanityMessageTriggerKey;
  final bool isFiltering;

  const RecruitApplyState({
    this.isLoading = false,
    this.profanityMessage,
    this.profanityMessageTriggerKey = 0,
    this.isFiltering = false,
  });

  RecruitApplyState copyWith({
    bool? isLoading,
    String? profanityMessage,
    int? profanityMessageTriggerKey,
    bool? isFiltering,
  }) {
    return RecruitApplyState(
      isLoading: isLoading ?? this.isLoading,
      profanityMessage: profanityMessage,
      profanityMessageTriggerKey:
          profanityMessageTriggerKey ?? this.profanityMessageTriggerKey,
      isFiltering: isFiltering ?? this.isFiltering,
    );
  }
}
