import 'dart:async';
import 'package:dongsoop/data/notification/channel/push_channel.dart';
import 'package:dongsoop/domain/notification/entity/push_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dongsoop/domain/board/recruit/enum/recruit_type.dart';
import 'package:dongsoop/domain/board/recruit/apply/enum/recruit_applicant_viewer.dart';
import 'package:dongsoop/presentation/home/view_models/notification_badge_view_model.dart';
import 'package:dongsoop/presentation/home/view_models/notification_view_model.dart';
import 'package:dongsoop/presentation/board/recruit/apply/view_models/recruit_applicant_list_view_model.dart';
import 'package:dongsoop/presentation/board/recruit/apply/view_models/recruit_applicant_detail_view_model.dart';
import 'package:dongsoop/core/routing/push_router.dart';
import 'package:dongsoop/providers/activity_context_providers.dart';
import 'package:dongsoop/providers/chat_providers.dart';

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

  final Map<String, DateTime> _lastListRefreshedAtByKey = <String, DateTime>{};
  static const Duration _listDebounceDuration = Duration(milliseconds: 180);
  DateTime? _lastDetailRefreshedAt;

  final Map<int, DateTime> _readOnceCacheTimestamps = <int, DateTime>{};
  static const Duration _readOnceTimeToLive = Duration(minutes: 5);

  void start() {
    if (_isStarted) return;
    _isStarted = true;

    final pushChannel = PushChannel.instance();
    pushChannel.bind();

    _onPush = pushChannel.onPush.listen((payload) async {
      if (payload.type.isEmpty) return;

      if (payload.type == 'CHAT') {
        final inChatList = ref.read(activeChatListContextProvider);
        if (inChatList == true) {
          final now = DateTime.now();
          if (_lastChatListRefreshedAt == null ||
              now.difference(_lastChatListRefreshedAt!) > _chatListDebounceDuration) {
            _lastChatListRefreshedAt = now;
            await ref.read(chatViewModelProvider.notifier).loadChatRooms();
          }
        }
        return;
      }


      bool anyTargetMatched = false;
      anyTargetMatched |= _maybeRefreshRecruitList(payload);
      anyTargetMatched |= _maybeRefreshRecruitDetail(payload);

      if (anyTargetMatched && payload.id != null && payload.id! > 0) {
        await _readOnce(payload.id!);
      }

      if (payload.badge != null) {
        ref.read(notificationBadgeViewModelProvider.notifier).setBadge(payload.badge!);
      } else {
        _refreshBadgeThrottled(force: false);
      }
    });

    _onPushTap = pushChannel.onPushTap.listen((payload) async {
      if (payload.type.isEmpty) return;

      if (payload.type == 'CHAT') {
        if (payload.value != null) {
          try {
            await PushRouter.routeFromTypeValue(type: payload.type, value: payload.value!);
          } catch (_) {}
        }
        return;
      }

      if (_isSameRecruitListScreen(payload) || _isSameRecruitDetailScreen(payload)) {
        if (payload.id != null && payload.id! > 0) {
          await _readOnce(payload.id!);
        }
        if (payload.badge != null) {
          ref.read(notificationBadgeViewModelProvider.notifier).setBadge(payload.badge!);
        } else {
          _refreshBadgeThrottled(force: false);
        }
        return;
      }

      if (payload.type.isNotEmpty && payload.value != null) {
        try {
          await PushRouter.routeFromTypeValue(type: payload.type, value: payload.value!);
        } catch (_) {}
      }

      if (payload.id != null && payload.id! > 0) {
        await _readOnce(payload.id!);
      }
      if (payload.badge != null) {
        ref.read(notificationBadgeViewModelProvider.notifier).setBadge(payload.badge!);
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

    if (lastReadAt != null && now.difference(lastReadAt) < _readOnceTimeToLive) {
      return;
    }

    _readOnceCacheTimestamps[notificationId] = now;
    _purgeOldReadOnceEntries(now);

    try {
      await ref.read(notificationViewModelProvider.notifier).read(notificationId);
    } catch (_) {
    }
  }

  void _purgeOldReadOnceEntries(DateTime now) {
    if (_readOnceCacheTimestamps.length < 128) return;
    _readOnceCacheTimestamps.removeWhere((_, timestamp) => now.difference(timestamp) > _readOnceTimeToLive);
  }

  void _refreshBadgeThrottled({required bool force}) {
    final DateTime now = DateTime.now();
    if (!force &&
        _lastBadgeUpdatedAt != null &&
        now.difference(_lastBadgeUpdatedAt!) < const Duration(milliseconds: 350)) {
      return;
    }
    _lastBadgeUpdatedAt = now;
    ref.read(notificationBadgeViewModelProvider.notifier).refreshBadge(force: force);
  }

  RecruitType? _mapRecruitType(String upperCaseType) {
    if (upperCaseType.contains('_STUDY')) return RecruitType.STUDY;
    if (upperCaseType.contains('_PROJECT')) return RecruitType.PROJECT;
    if (upperCaseType.contains('_TUTORING')) return RecruitType.TUTORING;
    return null;
  }

  bool _maybeRefreshRecruitList(PushPayload payload) {
    final activeContext = ref.read(activeRecruitListContextProvider);
    if (activeContext == null) return false;

    final String typeString = payload.type;
    if (!typeString.startsWith('RECRUITMENT_') ||
        !typeString.contains('_APPLY') ||
        typeString.contains('_RESULT')) {
      return false;
    }

    final RecruitType? pushRecruitType = _mapRecruitType(typeString);
    final int? pushBoardId = int.tryParse(payload.value ?? '');
    if (pushRecruitType == null || pushBoardId == null) return false;

    if (pushRecruitType == activeContext.type && pushBoardId == activeContext.boardId) {
      final String key = '${activeContext.type}|${activeContext.boardId}';
      final DateTime now = DateTime.now();
      final DateTime? lastRefreshedAt = _lastListRefreshedAtByKey[key];
      if (lastRefreshedAt != null && now.difference(lastRefreshedAt) < _listDebounceDuration) {
        return false;
      }
      _lastListRefreshedAtByKey[key] = now;

      if (_lastListRefreshedAtByKey.length > 64) {
        _lastListRefreshedAtByKey.removeWhere((_, timestamp) => now.difference(timestamp) > const Duration(seconds: 5));
      }

      ref.invalidate(
        recruitApplicantListViewModelProvider(
          boardId: activeContext.boardId,
          type: activeContext.type,
        ),
      );
      return true;
    }
    return false;
  }

  bool _maybeRefreshRecruitDetail(PushPayload payload) {
    final activeContext = ref.read(activeRecruitDetailContextProvider);
    if (activeContext == null) return false;

    if (activeContext.viewer != RecruitApplicantViewer.APPLICANT) {
      return false;
    }

    final String typeString = payload.type;
    if (!typeString.contains('_APPLY_RESULT')) return false;

    final RecruitType? pushRecruitType = _mapRecruitType(typeString);
    final int? pushBoardId = int.tryParse(payload.value ?? '');
    if (pushRecruitType == null || pushBoardId == null) return false;

    if (pushRecruitType == activeContext.type && pushBoardId == activeContext.boardId) {
      final DateTime now = DateTime.now();
      if (_lastDetailRefreshedAt != null &&
          now.difference(_lastDetailRefreshedAt!) < const Duration(milliseconds: 300)) {
        return false;
      }
      _lastDetailRefreshedAt = now;

      ref.invalidate(
        recruitApplicantDetailViewModelProvider(
          RecruitApplicantDetailArgs(
            viewer: activeContext.viewer,
            type: activeContext.type,
            boardId: activeContext.boardId,
            memberId: activeContext.memberId,
          ),
        ),
      );
      return true;
    }
    return false;
  }

  bool _isSameRecruitListScreen(PushPayload payload) {
    final activeContext = ref.read(activeRecruitListContextProvider);
    if (activeContext == null) return false;

    final String typeString = payload.type;
    if (!typeString.startsWith('RECRUITMENT_') ||
        !typeString.contains('_APPLY') ||
        typeString.contains('_RESULT')) {
      return false;
    }

    final RecruitType? pushType = _mapRecruitType(typeString);
    final int? pushBoardId = int.tryParse(payload.value ?? '');
    if (pushType == null || pushBoardId == null) return false;

    return pushType == activeContext.type && pushBoardId == activeContext.boardId;
  }

  bool _isSameRecruitDetailScreen(PushPayload payload) {
    final activeContext = ref.read(activeRecruitDetailContextProvider);
    if (activeContext == null) return false;

    if (activeContext.viewer != RecruitApplicantViewer.APPLICANT) return false;

    final String typeString = payload.type;
    if (!typeString.contains('_APPLY_RESULT')) return false;

    final RecruitType? pushType = _mapRecruitType(typeString);
    final int? pushBoardId = int.tryParse(payload.value ?? '');
    if (pushType == null || pushBoardId == null) return false;

    return pushType == activeContext.type && pushBoardId == activeContext.boardId;
  }
}
