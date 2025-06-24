import 'package:dongsoop/domain/chat/model/ui_chat_room.dart';

class ChatState {
  final bool isLoading;
  final String? errorMessage;
  final List<UiChatRoom>? chatRooms;

  ChatState({
    required this.isLoading,
    this.errorMessage,
    this.chatRooms,
  });

  ChatState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<UiChatRoom>? chatRooms,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      chatRooms: chatRooms ?? this.chatRooms,
    );
  }
}
