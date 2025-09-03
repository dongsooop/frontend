class Chatbot {
  final String id;
  final bool isMe;
  final String text;
  final bool typing;

  Chatbot({
    required this.id,
    required this.isMe,
    required this.text,
    this.typing = false,
  });

  Chatbot copyWith({String? text, bool? typing}) => Chatbot(
    id: id,
    isMe: isMe,
    text: text ?? this.text,
    typing: typing ?? this.typing,
  );
}