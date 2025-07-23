import 'dart:ui';

import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> LoginRequiredDialog(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    pageBuilder: (_, __, ___) => Stack(
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.6, sigmaY: 1.4),
          child: Container(
            color: Colors.black.withAlpha((255 * 0.3).round()),
          ),
        ),
        Center(
          child: CustomConfirmDialog(
            title: '로그인이 필요해요',
            content: '이 서비스를 이용하려면\n로그인을 해야 해요!',
            isSingleAction: false,
            confirmText: '확인',
            onConfirm: () {
              context.push(RoutePaths.signIn);
            },
            onCancel: () {},
          ),
        ),
      ],
    ),
  );
}
