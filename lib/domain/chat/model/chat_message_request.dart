class ChatMessageRequest {
  final String roomId;
  final String content;
  final String type;
  final String? senderNickName;

  ChatMessageRequest({
    required this.roomId,
    required this.content,
    required this.type,
    this.senderNickName,
  });
}