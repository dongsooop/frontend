class Chatbot {
  final String id;
  final bool isMe;
  final String text;
  final bool typing;
  final bool isSystem;

  Chatbot({
    required this.id,
    required this.isMe,
    required this.text,
    this.typing = false,
    this.isSystem = false,
  });

  Chatbot copyWith({
    String? text,
    bool? typing,
    bool? isSystem,
  }) => Chatbot(
    id: id,
    isMe: isMe,
    text: text ?? this.text,
    typing: typing ?? this.typing,
    isSystem: isSystem ?? this.isSystem,
  );

  factory Chatbot.system({
    required String id,
    required String text,
  }) => Chatbot(id: id, isMe: false, text: text, isSystem: true);
}