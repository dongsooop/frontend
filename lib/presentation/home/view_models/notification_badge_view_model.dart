import 'dart:async';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dongsoop/presentation/home/providers/notification_use_case_provider.dart';

part 'notification_badge_view_model.g.dart';

@Riverpod(keepAlive: true)
class NotificationBadgeViewModel extends _$NotificationBadgeViewModel {
  bool _loading = false;
  bool get isLoading => _loading;

  @override
  int build() {
    ref.listen(userSessionProvider, (prev, next) {
      final userPrev = prev;
      final userNext = next;

      if (userPrev != null && userNext == null) {
        state = 0;
      }

      if (userPrev == null && userNext != null) {
        unawaited(refreshBadge(force: true));
      }
    });

    return 0;
  }

  Future<void> refreshBadge({int maxRetry = 1, bool force = false}) async {
    final user = ref.read(userSessionProvider);
    if (user == null) {
      state = 0;
      return;
    }

    if (_loading && !force) return;

    _loading = true;
    int attempt = 0;

    try {
      final badge = ref.read(notificationUseCaseProvider);

      while (true) {
        try {
          final count = await badge.unreadOnly();
          state = _cap99(count);
          break;
        } catch (e) {
          if (attempt++ >= maxRetry) {
            rethrow;
          }
          await Future<void>.delayed(const Duration(milliseconds: 200));
        }
      }
    } catch (_) {
    } finally {
      _loading = false;
    }
  }

  void setBadge(int v) {
    state = _cap99(v);
  }

  int _cap99(int v) => v <= 0 ? 0 : (v > 99 ? 99 : v);
}