import 'package:dongsoop/domain/chat/model/blind_date/blind_date_message.dart';
import 'package:dongsoop/presentation/chat/widgets/message_action_sheet.dart';
import 'package:dongsoop/presentation/report/model/message_report_target.dart';
import 'package:dongsoop/presentation/report/widgets/message_report_bottom_sheet.dart';
import 'package:flutter/material.dart';

bool canReportBlindDateMessage(
  BlindDateMessage message, {
  required int? currentUserId,
  required String? sessionId,
}) {
  return currentUserId != null &&
      sessionId?.trim().isNotEmpty == true &&
      message.type.toUpperCase() == 'USER' &&
      message.memberId != currentUserId &&
      message.messageId?.trim().isNotEmpty == true;
}

Future<void> showBlindDateMessageActions(
  BuildContext context, {
  required BlindDateMessage message,
  required int? currentUserId,
  required String? sessionId,
}) async {
  final allowReport = canReportBlindDateMessage(
    message,
    currentUserId: currentUserId,
    sessionId: sessionId,
  );
  final action = await MessageActionSheet.show(
    context,
    allowReport: allowReport,
  );
  if (!context.mounted || action == null) return;

  switch (action) {
    case MessageAction.copy:
      await copyMessageToClipboard(context, message.message);
    case MessageAction.report:
      if (!allowReport) return;
      final reported = await MessageReportBottomSheet.show(
        context,
        target: BlindDateMessageReportTarget(
          sessionId: sessionId!,
          messageId: message.messageId!,
        ),
      );
      if (!context.mounted || reported != true) return;
      showMessageActionFeedback(context, '신고가 접수되었습니다.');
  }
}
