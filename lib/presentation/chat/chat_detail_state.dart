import 'package:dongsoop/domain/chat/model/chat_room_detail.dart';

class ChatDetailState {
  final bool isLoading;
  final String? errorMessage;
  final Map<String, String> nicknameMap;
  final int? otherUserId;
  final ChatRoomDetail? roomDetail;

  ChatDetailState({
    required this.isLoading,
    this.errorMessage,
    this.nicknameMap = const {},
    this.otherUserId,
    this.roomDetail,
  });

  ChatDetailState copyWith({
    bool? isLoading,
    String? errorMessage,
    Map<String, String>? nicknameMap,
    int? otherUserId,
    ChatRoomDetail? roomDetail,
  }) {
    return ChatDetailState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      nicknameMap: nicknameMap ?? this.nicknameMap,
      otherUserId: otherUserId ?? this.otherUserId,
      roomDetail: roomDetail ?? this.roomDetail,
    );
  }
}
