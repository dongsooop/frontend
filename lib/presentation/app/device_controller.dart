import 'package:dongsoop/core/storage/firebase_messaging_service.dart';
import 'package:dongsoop/core/storage/local_notifications_service.dart';
import 'package:dongsoop/presentation/home/view_models/notification_badge_view_model.dart';
import 'package:dongsoop/presentation/home/view_models/notification_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceControllerProvider = Provider((ref) => DeviceController(ref));

class DeviceController {
  final Ref _ref;
  DeviceController(this._ref);

  void init() {
    final fms = FirebaseMessagingService.instance();
    final lns = LocalNotificationsService.instance();

    lns.init();

    fms.setBadgeCallback((n) {
      try {
        _ref.read(notificationBadgeViewModelProvider.notifier).setBadge(n);
      } catch (e) {}
    });

    fms.setBadgeRefreshCallback(() async {
      await refreshBadge(force: false);
    });

    fms.setReadCallback((id) async {
      await readNotification(id);
    });
    fms.init(localNotificationsService: lns);

    _ref.listen(notificationBadgeViewModelProvider, (prev, next) {
      if (prev != next) {
        fms.updateNativeBadge(next);
      }
    });
  }

  Future<void> readNotification(int id) async {
    try {
      await _ref.read(notificationViewModelProvider.notifier).read(id);
      await refreshBadge(force: true);
    } catch (e) {
      await refreshBadge(force: true);
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