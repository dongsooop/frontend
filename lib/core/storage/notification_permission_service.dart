import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';

class NotificationPermissionService {
  final PreferencesService _prefs;

  NotificationPermissionService(this._prefs);

  Future<void> requestOnce() async {
    final requested = await _prefs.isNotificationPermissionRequested();
    if (requested) return;

    final status = await Permission.notification.status;

    if (status.isDenied) {
      await Permission.notification.request();
    }
    await _prefs.setNotificationPermissionRequested();
  }
}

final notificationPermissionServiceProvider = Provider<NotificationPermissionService>((ref) {
  final prefs = ref.read(preferencesProvider);
  return NotificationPermissionService(prefs);
});
