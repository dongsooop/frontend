class BlindDateDetailState {
  final bool isConnecting;
  final bool isFrozen;
  final String? sessionId;
  final Map<String, dynamic>? joined;       // { sessionId, volunteer }
  final String nickname;
  final Map<int, String> participants;
  final String? disconnectReason;

  BlindDateDetailState({
    this.isConnecting = false,
    this.isFrozen = false,
    this.sessionId,
    this.joined,
    this.nickname = '',
    this.participants = const {},
    this.disconnectReason,
  });

  BlindDateDetailState copyWith({
    bool? isConnecting,
    bool? isFrozen,
    String? sessionId,
    Map<String, dynamic>? joined,
    String? nickname,
    Map<int, String>? participants,
    String? disconnectReason,
  }) {
    return BlindDateDetailState(
      isConnecting: isConnecting ?? this.isConnecting,
      isFrozen: isFrozen ?? this.isFrozen,
      sessionId: sessionId ?? this.sessionId,
      joined: joined ?? this.joined,
      nickname: nickname ?? this.nickname,
      participants: participants ?? this.participants,
      disconnectReason: disconnectReason ?? this.disconnectReason,
    );
  }
}