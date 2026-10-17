enum BlindDateVoteIntroStage { none, firstMessage, secondMessage }

class BlindDateDetailState {
  final String? sessionId;
  final bool isConnecting;
  final bool isFrozen;
  final int volunteer;
  final int maxCount;
  final String nickname;
  final Map<int, String> participants;
  final String? ended;
  final String? disconnectReason;
  final bool isKicked;
  final bool isLoading;
  final BlindDateVoteIntroStage voteIntroStage;
  final bool isVoteTime;

  bool get isVotePreparing => voteIntroStage != BlindDateVoteIntroStage.none;

  BlindDateDetailState({
    this.sessionId,
    this.isConnecting = false,
    this.isFrozen = false,
    this.volunteer = 0,
    this.maxCount = 7,
    this.nickname = '',
    this.participants = const {},
    this.ended,
    this.disconnectReason,
    this.isKicked = false,
    this.isLoading = false,
    this.voteIntroStage = BlindDateVoteIntroStage.none,
    this.isVoteTime = false,
  });

  BlindDateDetailState copyWith({
    String? sessionId,
    bool clearSessionId = false,
    bool? isConnecting,
    bool? isFrozen,
    int? volunteer,
    int? maxCount,
    String? nickname,
    Map<int, String>? participants,
    String? ended,
    bool clearEnded = false,
    String? disconnectReason,
    bool clearDisconnectReason = false,
    bool? isKicked,
    bool? isLoading,
    BlindDateVoteIntroStage? voteIntroStage,
    bool? isVoteTime,
  }) {
    return BlindDateDetailState(
      sessionId: clearSessionId ? null : sessionId ?? this.sessionId,
      isConnecting: isConnecting ?? this.isConnecting,
      isFrozen: isFrozen ?? this.isFrozen,
      volunteer: volunteer ?? this.volunteer,
      maxCount: maxCount ?? this.maxCount,
      nickname: nickname ?? this.nickname,
      participants: participants ?? this.participants,
      ended: clearEnded ? null : ended ?? this.ended,
      disconnectReason: clearDisconnectReason
          ? null
          : disconnectReason ?? this.disconnectReason,
      isKicked: isKicked ?? this.isKicked,
      isLoading: isLoading ?? this.isLoading,
      voteIntroStage: voteIntroStage ?? this.voteIntroStage,
      isVoteTime: isVoteTime ?? this.isVoteTime,
    );
  }
}
