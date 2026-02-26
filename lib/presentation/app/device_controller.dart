import 'package:dongsoop/core/routing/route_paths.dart';
import 'package:dongsoop/core/routing/router.dart';
import 'package:dongsoop/core/storage/firebase_messaging_service.dart';
import 'package:dongsoop/core/storage/local_notifications_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/presentation/home/view_models/notification_badge_view_model.dart';
import 'package:dongsoop/presentation/home/view_models/notification_view_model.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/core/presentation/components/single_action_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceControllerProvider = Provider((ref) => DeviceController(ref));

class DeviceController {
  final Ref _ref;
  DeviceController(this._ref);

  void init() {
    final fms = FirebaseMessagingService.instance();
    final lns = LocalNotificationsService.instance();

    fms.setForceLogoutCallback(_handleForceLogout);

    lns.init();
    fms.init(localNotificationsService: lns);

    // 배지 상태 감시: ViewModel 숫자가 바뀌면 네이티브 배지 업데이트
    _ref.listen(notificationBadgeViewModelProvider, (prev, next) {
      if (prev != next) {
        fms.updateNativeBadge(next);
      }
    });

    // 읽음 콜백: 알림 클릭 시 서버에 읽음 요청 후 배지 새로고침
    fms.setReadCallback((id) async {
      try {
        await _ref.read(notificationViewModelProvider.notifier).read(id);
        await refreshBadge(force: true);
      } catch (_) {
        await refreshBadge(force: true);
      }
    });

    fms.setBadgeCallback((n) {
      try {
        _ref.read(notificationBadgeViewModelProvider.notifier).setBadge(n);
      } catch (_) {}
    });

    fms.setBadgeRefreshCallback(() async {
      await refreshBadge(force: false);
    });
  }

  Future<void> _handleForceLogout() async {
    try {
      await _ref.read(secureStorageProvider).delete();
      _ref.read(userSessionProvider.notifier).state = null;
      _ref.invalidate(userSessionProvider);
      _ref.invalidate(myPageViewModelProvider);

      _ref.read(notificationBadgeViewModelProvider.notifier).setBadge(0);

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final context = rootNavigatorKey.currentContext;
        if (context != null && context.mounted) {
          await SingleActionDialog(
            context,
            title: '로그아웃 알림',
            content: '보안을 위해 로그아웃 되었어요.\n다시 로그인해주세요.',
            onConfirm: () => router.go(RoutePaths.mypage),
          );
        } else {
          router.go(RoutePaths.mypage);
        }
      });
    } catch (e) {
      router.go(RoutePaths.mypage);
    }
  }

  DateTime? _lastBadgeRefreshAt;
  Future<void> refreshBadge({required bool force}) async {
    final now = DateTime.now();
    if (!force &&
        _lastBadgeRefreshAt != null &&
        now.difference(_lastBadgeRefreshAt!) < const Duration(milliseconds: 350)) {
      return;
    }
    _lastBadgeRefreshAt = now;
    try {
      await _ref.read(notificationBadgeViewModelProvider.notifier).refreshBadge(force: force);
    } catch (_) {}
  }
}