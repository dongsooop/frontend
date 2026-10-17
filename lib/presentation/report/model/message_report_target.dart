sealed class MessageReportTarget {
  const MessageReportTarget();
}

final class ChatMessageReportTarget extends MessageReportTarget {
  final String roomId;
  final String messageId;

  const ChatMessageReportTarget({
    required this.roomId,
    required this.messageId,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ChatMessageReportTarget &&
            roomId == other.roomId &&
            messageId == other.messageId;
  }

  @override
  int get hashCode => Object.hash(roomId, messageId);
}

final class BlindDateMessageReportTarget extends MessageReportTarget {
  final String sessionId;
  final String messageId;

  const BlindDateMessageReportTarget({
    required this.sessionId,
    required this.messageId,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlindDateMessageReportTarget &&
            sessionId == other.sessionId &&
            messageId == other.messageId;
  }

  @override
  int get hashCode => Object.hash(sessionId, messageId);
}
