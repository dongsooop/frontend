import 'dart:async';

import 'package:dongsoop/core/presentation/components/single_action_dialog.dart';
import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/core/routing/router.dart';
import 'package:dongsoop/domain/auth/enum/session_end_reason.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:dongsoop/providers/realtime_providers.dart';
import 'package:dongsoop/providers/session_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final sessionObserverProvider = Provider<void>((ref) {
  final sessionManager = ref.watch(sessionManagerProvider);
  var isDialogOpen = false;

  final chatSessionSubscription = ref
      .watch(stompServiceProvider)
      .sessionEndStream
      .listen(sessionManager.end);
  final blindDateSessionSubscription = ref
      .watch(blindDateStompServiceProvider)
      .sessionEndStream
      .listen(sessionManager.end);
  ref.onDispose(() {
    unawaited(chatSessionSubscription.cancel());
    unawaited(blindDateSessionSubscription.cancel());
  });

  ref.listen(userSessionProvider, (previous, next) {
    if (previous == null && next != null) {
      sessionManager.activateSession();
    }
  });

  ref.listen<SessionEndReason?>(sessionEndReasonProvider, (previous, next) {
    if (next == null) return;

    ref.read(userSessionProvider.notifier).state = null;
    ref.read(myPageViewModelProvider.notifier).reset();
    ref.read(chatViewModelProvider.notifier).resetForSessionEnd();
    ref.read(chatDetailViewModelProvider.notifier).resetForSessionEnd();
    ref.read(blindDateMessagesProvider.notifier).clear();

    final context = rootNavigatorKey.currentContext;
    if (context == null || isDialogOpen) return;
    isDialogOpen = true;

    final isSanctioned = next == SessionEndReason.sanctioned;

    SingleActionDialog(
      context,
      title: isSanctioned ? '이용 제한 안내' : '로그아웃 알림',
      content: isSanctioned
          ? '현재 제재 중인 계정이라 로그아웃되었어요.\n자세한 내용은 다시 로그인해 확인해 주세요.'
          : '보안을 위해 로그아웃 되었어요. \n다시 로그인해 주세요.',
      confirmText: '확인',
      onConfirm: () {
        isDialogOpen = false;
        ref.read(sessionEndReasonProvider.notifier).state = null;
        context.go(RoutePaths.mypage);
      },
    );
  });
});
