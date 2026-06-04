import 'package:dongsoop/domain/chat/model/chat_room.dart';

class ChatState {
  final bool isLoading;
  final String? errorMessage;
  final List<ChatRoom>? chatRooms;
  final String? isBlindDateOpened;

  ChatState({
    required this.isLoading,
    this.errorMessage,
    this.chatRooms,
    this.isBlindDateOpened,
  });

  ChatState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ChatRoom>? chatRooms,
    String? isBlindDateOpened,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      chatRooms: chatRooms ?? this.chatRooms,
      isBlindDateOpened: isBlindDateOpened,
    );
  }
}
