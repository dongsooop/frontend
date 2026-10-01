class BlindDateDetailState {
  final bool isConnecting;
  final bool isFrozen;
  final int volunteer;
  final int maxCount;
  final String nickname;
  final Map<int, String> participants;
  final String? match;
  final String? ended;
  final String? disconnectReason;
  final bool isLoading;
  final bool isVoteTime;

  BlindDateDetailState({
    this.isConnecting = false,
    this.isFrozen = false,
    this.volunteer = 0,
    this.maxCount = 7,
    this.nickname = '',
    this.participants = const {},
    this.match,
    this.ended,
    this.disconnectReason,
    this.isLoading = false,
    this.isVoteTime = false,
  });

  BlindDateDetailState copyWith({
    bool? isConnecting,
    bool? isFrozen,
    int? volunteer,
    int? maxCount,
    String? nickname,
    Map<int, String>? participants,
    String? match,
    String? ended,
    String? disconnectReason,
    bool? isLoading,
    bool? isVoteTime,
  }) {
    return BlindDateDetailState(
      isConnecting: isConnecting ?? this.isConnecting,
      isFrozen: isFrozen ?? this.isFrozen,
      volunteer: volunteer ?? this.volunteer,
      maxCount: maxCount ?? this.maxCount,
      nickname: nickname ?? this.nickname,
      participants: participants ?? this.participants,
      match: match ?? this.match,
      ended: ended ?? this.ended,
      disconnectReason: disconnectReason ?? this.disconnectReason,
      isLoading: isLoading ?? this.isLoading,
      isVoteTime: isVoteTime ?? this.isVoteTime,
    );
  }
}
