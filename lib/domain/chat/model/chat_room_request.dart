import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room_request.freezed.dart';
part 'chat_room_request.g.dart';

@freezed
@JsonSerializable()
class ChatRoomRequest with _$ChatRoomRequest {
  final int targetUserId;
  final RecruitType recruitType;
  final int boardId;
  final String boardTitle;

  ChatRoomRequest({
    required this.targetUserId,
    required this.recruitType,
    required this.boardId,
    required this.boardTitle,
  });

  Map<String, dynamic> toJson() => _$ChatRoomRequestToJson(this);
}