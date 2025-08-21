import 'package:dongsoop/domain/chat/model/chat_room.dart';

class ChatState {
  final bool isLoading;
  final String? errorMessage;
  final List<ChatRoom>? chatRooms;

  ChatState({
    required this.isLoading,
    this.errorMessage,
    this.chatRooms,
  });

  ChatState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ChatRoom>? chatRooms,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      chatRooms: chatRooms ?? this.chatRooms,
    );
  }
}
