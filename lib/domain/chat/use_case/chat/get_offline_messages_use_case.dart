import 'package:dongsoop/domain/chat/repository/chat_repository.dart';
import 'package:dongsoop/domain/chat/model/chat_message.dart';

class GetOfflineMessagesUseCase {
  final ChatRepository _chatRepository;

  GetOfflineMessagesUseCase(
    this._chatRepository,
  );

  Future<List<ChatMessage>> execute(String roomId) async {
    final messages = await _chatRepository.getOfflineMessages(roomId) ?? [];
    if (messages.isEmpty) return [];

    final localLatest = await _chatRepository.getLatestMessage(roomId);

    final List<ChatMessage> result = [];

    if (localLatest == null || !_isSameDate(localLatest.timestamp, messages.first.timestamp)) {
      final dateOnly = _extractDate(messages.first.timestamp);
      result.add(ChatMessage.dateMessage(roomId, dateOnly));
    }

    DateTime? lastDate = _extractDate(localLatest?.timestamp);

    for (final msg in messages) {
      final currentDate = _extractDate(msg.timestamp);

      // 날짜가 바뀌었으면 날짜 메시지 추가
      if (lastDate == null || !currentDate.isAtSameMomentAs(lastDate)) {
        result.add(ChatMessage.dateMessage(roomId, currentDate));
        lastDate = currentDate;
      }

      result.add(msg);
    }

    return result;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  DateTime _extractDate(DateTime? dt) {
    if (dt == null) return DateTime(0000);
    return DateTime(dt.year, dt.month, dt.day);
  }
}