import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum MessageAction {
  copy,
  report,
}

class MessageActionSheet {
  const MessageActionSheet._();

  static Future<MessageAction?> show(
    BuildContext context, {
    required bool allowReport,
  }) {
    return showCupertinoModalPopup<MessageAction>(
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
                  MessageAction.copy,
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
                    MessageAction.report,
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

Future<void> copyMessageToClipboard(
  BuildContext context,
  String message,
) async {
  await Clipboard.setData(ClipboardData(text: message));
  if (!context.mounted) return;
  showMessageActionFeedback(context, '메시지를 복사했습니다.');
}

void showMessageActionFeedback(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
