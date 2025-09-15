class BlindDateDetailState {
  final bool isConnecting;
  final bool isFrozen;
  final String? sessionId;
  final int volunteer;
  final String nickname;
  final Map<int, String> participants;
  final String? disconnectReason;

  BlindDateDetailState({
    this.isConnecting = false,
    this.isFrozen = false,
    this.sessionId,
    this.volunteer = 0,
    this.nickname = '',
    this.participants = const {},
    this.disconnectReason,
  });

  BlindDateDetailState copyWith({
    bool? isConnecting,
    bool? isFrozen,
    String? sessionId,
    int? volunteer,
    String? nickname,
    Map<int, String>? participants,
    String? disconnectReason,
  }) {
    return BlindDateDetailState(
      isConnecting: isConnecting ?? this.isConnecting,
      isFrozen: isFrozen ?? this.isFrozen,
      sessionId: sessionId ?? this.sessionId,
      volunteer: volunteer ?? this.volunteer,
      nickname: nickname ?? this.nickname,
      participants: participants ?? this.participants,
      disconnectReason: disconnectReason ?? this.disconnectReason,
    );
  }
}