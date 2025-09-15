class BlindDateDetailState {
  final bool isConnecting;
  final bool isFrozen;
  final String? sessionId;
  final Map<String, dynamic>? joined;       // { sessionId, volunteer }
  final String nickname;
  final Map<int, String> participants;      // id->name
  final List<Map<String, dynamic>> system;  // 시스템 메시지 기록
  final String? disconnectReason;

  BlindDateDetailState({
    this.isConnecting = false,
    this.isFrozen = false,
    this.sessionId,
    this.joined,
    this.nickname = '',
    this.participants = const {},
    this.system = const [],
    this.disconnectReason,
  });

  BlindDateDetailState copyWith({
    bool? isConnecting,
    bool? isFrozen,
    String? sessionId,
    Map<String, dynamic>? joined,
    String? nickname,
    Map<int, String>? participants,
    List<Map<String, dynamic>>? system,
    String? disconnectReason,
  }) {
    return BlindDateDetailState(
      isConnecting: isConnecting ?? this.isConnecting,
      isFrozen: isFrozen ?? this.isFrozen,
      sessionId: sessionId ?? this.sessionId,
      joined: joined ?? this.joined,
      nickname: nickname ?? this.nickname,
      participants: participants ?? this.participants,
      system: system ?? this.system,
      disconnectReason: disconnectReason ?? this.disconnectReason,
    );
  }
}