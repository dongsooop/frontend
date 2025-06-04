import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/cupertino.dart';

class CustomConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isSingleAction;
  final bool dismissOnConfirm;
  final bool dismissOnCancel;

  const CustomConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelText = '취소',
    this.confirmText = '확인',
    required this.onConfirm,
    this.onCancel,
    this.isSingleAction = false,
    this.dismissOnConfirm = true,
    this.dismissOnCancel = true,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: ColorStyles.white,
        primaryColor: ColorStyles.primaryColor,
      ),
      child: CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyles.largeTextBold.copyWith(color: ColorStyles.black),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            content,
            style: TextStyles.normalTextRegular.copyWith(
              color: ColorStyles.black,
            ),
          ),
        ),
        actions: isSingleAction
            ? [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    if (dismissOnConfirm && Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      onConfirm();
                    });
                  },
                  child: Text(
                    confirmText,
                    style: TextStyles.largeTextRegular.copyWith(
                      color: ColorStyles.primaryColor,
                    ),
                  ),
                ),
              ]
            : [
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    if (dismissOnCancel && Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                    if (onCancel != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        onCancel!();
                      });
                    }
                  },
                  child: Text(
                    cancelText,
                    style: TextStyles.largeTextRegular.copyWith(
                      color: ColorStyles.warning100,
                    ),
                  ),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    if (dismissOnConfirm && Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      onConfirm();
                    });
                  },
                  child: Text(
                    confirmText,
                    style: TextStyles.largeTextRegular.copyWith(
                      color: ColorStyles.primaryColor,
                    ),
                  ),
                ),
              ],
      ),
    );
  }
}
