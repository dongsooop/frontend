import 'dart:async';
import 'package:dongsoop/data/notification/channel/push_channel.dart';
import 'package:dongsoop/domain/notification/entity/push_event.dart';
import 'package:dongsoop/providers/eclass_link_restore_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dongsoop/presentation/home/view_models/notification_badge_view_model.dart';
import 'package:dongsoop/presentation/home/view_models/notification_view_model.dart';
import 'package:dongsoop/core/routing/push_router.dart';
import 'package:dongsoop/providers/activity_context_providers.dart';

final pushSyncControllerProvider = Provider<PushSyncController>((ref) {
  final controller = PushSyncController(ref);
  controller.start();
  ref.onDispose(controller.dispose);
  return controller;
});

class PushSyncController {
  final Ref ref;
  PushSyncController(this.ref);

  bool _isStarted = false;

  StreamSubscription<PushPayload>? _onPush;
  StreamSubscription<PushPayload>? _onPushTap;

  DateTime? _lastBadgeUpdatedAt;

  DateTime? _lastChatListRefreshedAt;
  static const Duration _chatListDebounceDuration = Duration(milliseconds: 250);

  final Map<int, DateTime> _readOnceCacheTimestamps = <int, DateTime>{};
  static const Duration _readOnceTimeToLive = Duration(minutes: 5);

  void start() {
    if (_isStarted) return;
    _isStarted = true;

    final pushChannel = PushChannel.instance();
    pushChannel.bind();

    _onPush = pushChannel.onPush.listen((payload) async {
      if (payload.type.isEmpty) return;

      if (isEclassRelinkPush(payload.type)) {
        await ref.read(eclassLinkRestoreControllerProvider).restoreIfExpired();
        return;
      }

      if (payload.type == 'CHAT') {
        final inChatList = ref.read(activeChatListContextProvider);
        if (inChatList == true) {
          final now = DateTime.now();
          if (_lastChatListRefreshedAt == null ||
              now.difference(_lastChatListRefreshedAt!) >
                  _chatListDebounceDuration) {
            _lastChatListRefreshedAt = now;
          }
        }
        return;
      }

      if (payload.badge != null) {
        ref
            .read(notificationBadgeViewModelProvider.notifier)
            .setBadge(payload.badge!);
      } else {
        _refreshBadgeThrottled(force: false);
      }
    });

    _onPushTap = pushChannel.onPushTap.listen((payload) async {
      if (payload.type.isEmpty) return;

      if (isEclassRelinkPush(payload.type)) {
        await ref.read(eclassLinkRestoreControllerProvider).restoreIfExpired();
        return;
      }

      try {
        if (payload.type == 'CHAT') {
          if (payload.value != null) {
            await PushRouter.routeFromTypeValue(
                type: payload.type, value: payload.value!);
          }
          return;
        }

        if (payload.type == 'NEW_DEVICE_LOGIN') {
          await PushRouter.routeFromTypeValue(
              type: payload.type, value: payload.value ?? '');
        } else {
          if (payload.value != null) {
            await PushRouter.routeFromTypeValue(
                type: payload.type, value: payload.value!);
          }
        }
      } catch (_) {}

      if (payload.id != null && payload.id! > 0) {
        await _readOnce(payload.id!);
      }
      if (payload.badge != null) {
        ref
            .read(notificationBadgeViewModelProvider.notifier)
            .setBadge(payload.badge!);
      } else {
        _refreshBadgeThrottled(force: false);
      }
    });
  }

  void dispose() {
    _onPush?.cancel();
    _onPushTap?.cancel();
    _onPush = null;
    _onPushTap = null;
    _isStarted = false;
  }

  Future<void> _readOnce(int notificationId) async {
    final DateTime now = DateTime.now();
    final DateTime? lastReadAt = _readOnceCacheTimestamps[notificationId];

    if (lastReadAt != null &&
        now.difference(lastReadAt) < _readOnceTimeToLive) {
      return;
    }

    _readOnceCacheTimestamps[notificationId] = now;
    _purgeOldReadOnceEntries(now);

    try {
      await ref
          .read(notificationViewModelProvider.notifier)
          .read(notificationId);
    } catch (_) {}
  }

  void _purgeOldReadOnceEntries(DateTime now) {
    if (_readOnceCacheTimestamps.length < 128) return;
    _readOnceCacheTimestamps.removeWhere(
        (_, timestamp) => now.difference(timestamp) > _readOnceTimeToLive);
  }

  void _refreshBadgeThrottled({required bool force}) {
    final DateTime now = DateTime.now();
    if (!force &&
        _lastBadgeUpdatedAt != null &&
        now.difference(_lastBadgeUpdatedAt!) <
            const Duration(milliseconds: 350)) {
      return;
    }
    _lastBadgeUpdatedAt = now;
    ref
        .read(notificationBadgeViewModelProvider.notifier)
        .refreshBadge(force: force);
  }

}
