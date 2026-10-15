import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/presentation/chat/widgets/message_action_sheet.dart';
import 'package:dongsoop/presentation/report/model/message_report_target.dart';
import 'package:dongsoop/presentation/report/widgets/message_report_bottom_sheet.dart';
import 'package:flutter/material.dart';

bool canReportChatMessage(
  ChatMessage message, {
  required int? currentUserId,
}) {
  return currentUserId != null &&
      message.type == 'CHAT' &&
      message.senderId != currentUserId &&
      message.messageId.trim().isNotEmpty;
}

Future<void> showChatMessageActions(
  BuildContext context, {
  required ChatMessage message,
  required int? currentUserId,
}) async {
  final allowReport = canReportChatMessage(
    message,
    currentUserId: currentUserId,
  );
  final action = await MessageActionSheet.show(
    context,
    allowReport: allowReport,
  );
  if (!context.mounted || action == null) return;

  switch (action) {
    case MessageAction.copy:
      await copyMessageToClipboard(context, message.content);
    case MessageAction.report:
      if (!allowReport) return;
      final reported = await MessageReportBottomSheet.show(
        context,
        target: ChatMessageReportTarget(
          roomId: message.roomId,
          messageId: message.messageId,
        ),
      );
      if (!context.mounted || reported != true) return;
      showMessageActionFeedback(context, '신고가 접수되었습니다.');
  }
}
