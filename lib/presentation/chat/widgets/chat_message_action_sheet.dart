import 'package:dongsoop/domain/chat/model/chat_message.dart';
import 'package:dongsoop/presentation/report/model/message_report_target.dart';
import 'package:dongsoop/presentation/report/widgets/message_report_bottom_sheet.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ChatMessageAction {
  copy,
  report,
}

bool canReportChatMessage(
  ChatMessage message, {
  required int? currentUserId,
}) {
  return currentUserId != null &&
      message.type == 'CHAT' &&
      message.senderId != currentUserId &&
      message.messageId.trim().isNotEmpty;
}

class ChatMessageActionSheet {
  const ChatMessageActionSheet._();

  static Future<ChatMessageAction?> show(
    BuildContext context, {
    required bool allowReport,
  }) {
    return showCupertinoModalPopup<ChatMessageAction>(
      context: context,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: CupertinoTheme(
          data: CupertinoThemeData(
            primaryColor: ColorStyles.primaryColor,
            textTheme: CupertinoTextThemeData(
              actionTextStyle: TextStyles.largeTextRegular.copyWith(
                color: ColorStyles.primaryColor,
              ),
            ),
          ),
          child: CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                onPressed: () => Navigator.of(sheetContext).pop(
                  ChatMessageAction.copy,
                ),
                child: Text(
                  '복사',
                  style: TextStyles.largeTextRegular.copyWith(
                    color: ColorStyles.primaryColor,
                  ),
                ),
              ),
              if (allowReport)
                CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.of(sheetContext).pop(
                    ChatMessageAction.report,
                  ),
                  child: Text(
                    '신고',
                    style: TextStyles.largeTextRegular.copyWith(
                      color: ColorStyles.warning100,
                    ),
                  ),
                ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.of(sheetContext).pop(),
              child: Text(
                '취소',
                style: TextStyles.largeTextBold.copyWith(
                  color: ColorStyles.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
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
  final action = await ChatMessageActionSheet.show(
    context,
    allowReport: allowReport,
  );
  if (!context.mounted || action == null) return;

  switch (action) {
    case ChatMessageAction.copy:
      await Clipboard.setData(ClipboardData(text: message.content));
      if (!context.mounted) return;
      _showMessage(context, '메시지를 복사했습니다.');
    case ChatMessageAction.report:
      if (!allowReport) return;
      final reported = await MessageReportBottomSheet.show(
        context,
        target: ChatMessageReportTarget(
          roomId: message.roomId,
          messageId: message.messageId,
        ),
      );
      if (!context.mounted || reported != true) return;
      _showMessage(context, '신고가 접수되었습니다.');
  }
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
