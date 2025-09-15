class BlindDateRequest {
  final String sessionId;
  final String message;
  final int senderId;

  BlindDateRequest({
    required this.sessionId,
    required this.message,
    required this.senderId,
  });
}