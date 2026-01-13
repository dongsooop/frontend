import 'dart:async';

import 'package:dongsoop/core/app_scaffold_messenger.dart';
import 'package:dongsoop/core/presentation/components/custom_confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'marketing_push_guard.dart';

String _todayLabel() {
  final now = DateTime.now();
  return '${now.month}월 ${now.day}일';
}

String _consentMessage({required bool enabled}) {
  return '${_todayLabel()} 광고성 푸시 알림'
      '${enabled ? '에 동의했어요' : '동의를 거부했어요'}';
}

Future<void> showMarketingPushDialog(
    BuildContext context,
    WidgetRef ref,
    ) async {
  final guard = ref.read(marketingPushGuardProvider);

  await showCupertinoDialog(
    context: context,
    useRootNavigator: true,
    barrierDismissible: false,
    builder: (_) => CustomConfirmDialog(
      title: '광고성 푸시 알림',
      content: '동숲에서 제공하는 더욱 다양한 정보를 받아봐요',
      cancelText: '나중에',
      confirmText: '동의',
      useRootNavigator: true,
      onCancel: () async {
        try {
          await guard.decline();
          showRootSnack(_consentMessage(enabled: false));
        } catch (_) {
          showRootSnack('알림 설정을 변경할 수 없어요. 잠시 후 다시 시도해 주세요.');
        }
      },
      onConfirm: () async {
        try {
          final ok = await guard.accept();
          if (ok == true) {
            showRootSnack(_consentMessage(enabled: true));
          } else {
            showRootSnack('알림 설정을 변경할 수 없어요. 잠시 후 다시 시도해 주세요.');
          }
        } catch (_) {
          showRootSnack('알림 설정을 변경할 수 없어요. 잠시 후 다시 시도해 주세요.');
        }
      },
    ),
  );
}