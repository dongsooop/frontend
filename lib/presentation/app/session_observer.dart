import 'package:dongsoop/core/presentation/components/single_action_dialog.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/core/routing/router.dart';
import 'package:dongsoop/providers/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final sessionObserverProvider = Provider<void>((ref) {
  ref.listen<bool>(sessionExpiredProvider, (previous, next) {
    if (next == true) {
      final context = rootNavigatorKey.currentContext;
      if (context == null) return;

      SingleActionDialog(
        context,
        title: '로그아웃 알림',
        content: '보안을 위해 로그아웃 되었어요. \n다시 로그인해 주세요.',
        confirmText: '확인',
        onConfirm: () {
          ref.read(sessionExpiredProvider.notifier).state = false;
          context.go(RoutePaths.mypage);
        },
      );
    }
  });
});