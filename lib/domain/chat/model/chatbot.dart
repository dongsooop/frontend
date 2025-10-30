class Chatbot {
  final String id;
  final bool isMe;
  final String text;
  final String? url;
  final bool typing;
  final bool isSystem;

  Chatbot({
    required this.id,
    required this.isMe,
    required this.text,
    this.url,
    this.typing = false,
    this.isSystem = false,
  });

  Chatbot copyWith({
    String? text,
    String? url,
    bool? typing,
    bool? isSystem,
  }) => Chatbot(
    id: id,
    isMe: isMe,
    text: text ?? this.text,
    url: url ?? this.url,
    typing: typing ?? this.typing,
    isSystem: isSystem ?? this.isSystem,
  );

  factory Chatbot.system({
    required String id,
    required String text,
  }) => Chatbot(id: id, isMe: false, text: text, isSystem: true);
}