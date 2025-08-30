import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dongsoop/presentation/home/providers/notification_use_case_provider.dart';

part 'notification_badge_view_model.g.dart';

@riverpod
class NotificationBadgeViewModel extends _$NotificationBadgeViewModel {
  bool _loading = false;

  @override
  int build() => 0;

  Future<void> refreshBadge({int maxRetry = 1}) async {
    if (_loading) return;
    _loading = true;
    int attempt = 0;

    try {
      final badge = ref.read(notificationUseCaseProvider);

      while (true) {
        try {
          final count = await badge.unreadOnly();
          state = _cap99(count);
          if (kDebugMode) debugPrint('[BadgeVM] unread=$state');
          break;
        } catch (e) {
          if (attempt++ >= maxRetry) rethrow;
          await Future<void>.delayed(const Duration(milliseconds: 200));
        }
      }
    } catch (e, st) {
      if (kDebugMode) debugPrint('[BadgeVM] refresh error: $e\n$st');
    } finally {
      _loading = false;
    }
  }

  int _cap99(int v) => v <= 0 ? 0 : (v > 99 ? 99 : v);
}
