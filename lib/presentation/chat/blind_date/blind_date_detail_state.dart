class BlindDateDetailState {
  final bool isConnecting;
  final bool isFrozen;
  final String? sessionId;                  // start 이벤트로 받은 세션
  final Map<String, dynamic>? joined;       // { sessionId, volunteer }
  final Map<String, dynamic>? joinInfo;     // { name, sessionId }
  final Map<int, String> participants;      // id->name
  final List<Map<String, dynamic>> system;  // 시스템 메시지 기록
  final String? disconnectReason;

  BlindDateDetailState({
    this.isConnecting = false,
    this.isFrozen = false,
    this.sessionId,
    this.joined,
    this.joinInfo,
    this.participants = const {},
    this.system = const [],
    this.disconnectReason,
  });

  BlindDateDetailState copyWith({
    bool? isConnecting,
    bool? isFrozen,
    String? sessionId,
    Map<String, dynamic>? joined,
    Map<String, dynamic>? joinInfo,
    Map<int, String>? participants,
    List<Map<String, dynamic>>? system,
    String? disconnectReason,
  }) {
    return BlindDateDetailState(
      isConnecting: isConnecting ?? this.isConnecting,
      isFrozen: isFrozen ?? this.isFrozen,
      sessionId: sessionId ?? this.sessionId,
      joined: joined ?? this.joined,
      joinInfo: joinInfo ?? this.joinInfo,
      participants: participants ?? this.participants,
      system: system ?? this.system,
      disconnectReason: disconnectReason ?? this.disconnectReason,
    );
  }
}