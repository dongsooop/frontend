import 'dart:ui';

import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginRequiredDialog extends StatelessWidget {
  final VoidCallback? onCancel;

  const LoginRequiredDialog({
    super.key,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
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
              dismissOnConfirm: false,
              onConfirm: () => context.go(RoutePaths.mypage),
              onCancel: onCancel,
            ),
          ),
        ],
      ),
    );
  }
}
