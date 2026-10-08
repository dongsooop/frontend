enum BlindDateVoteIntroStage { none, firstMessage, secondMessage }

class BlindDateDetailState {
  final bool isConnecting;
  final bool isFrozen;
  final int volunteer;
  final int maxCount;
  final String nickname;
  final Map<int, String> participants;
  final String? ended;
  final String? disconnectReason;
  final bool isLoading;
  final BlindDateVoteIntroStage voteIntroStage;
  final bool isVoteTime;

  bool get isVotePreparing => voteIntroStage != BlindDateVoteIntroStage.none;

  BlindDateDetailState({
    this.isConnecting = false,
    this.isFrozen = false,
    this.volunteer = 0,
    this.maxCount = 7,
    this.nickname = '',
    this.participants = const {},
    this.ended,
    this.disconnectReason,
    this.isLoading = false,
    this.voteIntroStage = BlindDateVoteIntroStage.none,
    this.isVoteTime = false,
  });

  BlindDateDetailState copyWith({
    bool? isConnecting,
    bool? isFrozen,
    int? volunteer,
    int? maxCount,
    String? nickname,
    Map<int, String>? participants,
    String? ended,
    String? disconnectReason,
    bool? isLoading,
    BlindDateVoteIntroStage? voteIntroStage,
    bool? isVoteTime,
  }) {
    return BlindDateDetailState(
      isConnecting: isConnecting ?? this.isConnecting,
      isFrozen: isFrozen ?? this.isFrozen,
      volunteer: volunteer ?? this.volunteer,
      maxCount: maxCount ?? this.maxCount,
      nickname: nickname ?? this.nickname,
      participants: participants ?? this.participants,
      ended: ended ?? this.ended,
      disconnectReason: disconnectReason ?? this.disconnectReason,
      isLoading: isLoading ?? this.isLoading,
      voteIntroStage: voteIntroStage ?? this.voteIntroStage,
      isVoteTime: isVoteTime ?? this.isVoteTime,
    );
  }
}
