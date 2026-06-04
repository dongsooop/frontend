import 'dart:ui';

import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:flutter/material.dart';

Future<void> SingleActionDialog(
    BuildContext context, {
      required String title,
      required String content,
      String confirmText = '확인',
      required VoidCallback onConfirm,
    }) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withAlpha((255 * 0.3).round()),
    useRootNavigator: true,
    pageBuilder: (context, _, __) {
      return Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.6, sigmaY: 1.4),
            child: Container(
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SafeArea(
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: CustomConfirmDialog(
                  title: title,
                  content: content,
                  confirmText: confirmText,
                  onConfirm: onConfirm,
                  isSingleAction: true,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
