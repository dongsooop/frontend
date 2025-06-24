import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/cupertino.dart';

void customActionSheet(
  BuildContext context, {
  VoidCallback? onEdit,
  required VoidCallback onDelete,
  String? deleteText,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
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
            if (onEdit != null)
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  onEdit();
                },
                child: Text(
                  '수정',
                  style: TextStyles.largeTextRegular.copyWith(
                    color: ColorStyles.primaryColor,
                  ),
                ),
              ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                onDelete();
              },
              isDestructiveAction: true,
              child: Text(
                deleteText ?? '삭제',
                style: TextStyles.largeTextRegular,
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
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
