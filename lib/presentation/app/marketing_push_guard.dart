import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/domain/notification/enum/notification_target.dart';
import 'package:dongsoop/presentation/setting/notification/view_model/notification_setting_view_model.dart';
import 'package:dongsoop/presentation/setting/notification/view_model/notification_types.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:dongsoop/providers/device_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketingPushGuardProvider = Provider<MarketingPushGuard>((ref) {
  return MarketingPushGuard(ref);
});

class MarketingPushGuard {
  final Ref ref;
  MarketingPushGuard(this.ref);

  PreferencesService get _prefs => ref.read(preferencesProvider);

  Future<bool> shouldShowDialog() async {
    final prompted = await _prefs.isAdsPushPrompted();
    return !prompted;
  }

  Future<bool> accept() async {
    try {
      await _applyConsentToServerAndLocal(nextValue: true);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> decline() async {
    await _applyConsentToServerAndLocal(nextValue: false);
  }

  Future<void> _applyConsentToServerAndLocal({required bool nextValue}) async {
    final user = ref.read(userSessionProvider);
    final target =
    user != null ? NotificationTarget.user : NotificationTarget.guest;

    final deviceToken =
    await ref.read(getFcmTokenUseCaseProvider).execute();
    if (deviceToken == null || deviceToken.isEmpty) {
      await _prefs.setAdsPushConsentGranted(nextValue);
      await _prefs.setAdsPushPrompted();
      return;
    }

    try {
      await ref.read(notificationSettingViewModelProvider.notifier).setToggle(
        target: target,
        deviceToken: deviceToken,
        notificationType: NotificationTypes.marketing,
        nextValue: nextValue,
      );
    } catch (_) {}
    finally {
      await _prefs.setAdsPushConsentGranted(nextValue);
      await _prefs.setAdsPushPrompted();
    }
  }
}