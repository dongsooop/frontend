class ChatMessageRequest {
  final String roomId;
  final String content;
  final String type;

  ChatMessageRequest({
    required this.roomId,
    required this.content,
    required this.type,
  });
}