import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dongsoop/presentation/notification/providers/notification_setting_provider.dart';
import 'package:dongsoop/domain/notification/entity/notification_enable_entity.dart';
import 'package:dongsoop/domain/notification/enum/notification_target.dart';
import 'package:dongsoop/domain/notification/repository/notification_setting_repository.dart';
import 'notification_setting_state.dart';
part 'notification_setting_view_model.g.dart';

@riverpod
class NotificationSettingViewModel extends _$NotificationSettingViewModel {
  late final NotificationSettingRepository _repo;

  @override
  NotificationSettingState build() {
    _repo = ref.watch(notificationSettingRepositoryProvider);
    return const NotificationSettingState();
  }

  Future<void> fetchSettings({
    required NotificationTarget target,
    required String deviceToken,
  }) async {
    try {
      final settings = await _repo.fetchSettings(
        target: target,
        deviceToken: deviceToken,
      );

      final mapped = <String, bool>{
        for (final e in settings.entries) e.key.code: e.value,
      };

      state = state.copyWith(
        enabled: {...state.enabled, ...mapped},
        error: null,
      );
    } catch (e, st) {
      if (kDebugMode) {
        print('[NotificationSettingViewModel.fetchSettings] $e\n$st');
      }

      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> setToggle({
    required NotificationTarget target,
    required String deviceToken,
    required String notificationType,
    required bool nextValue,
  }) async {
    if (state.isLoading(notificationType)) return;

    state = state.copyWith(
      enabled: {...state.enabled, notificationType: nextValue},
      loading: {...state.loading, notificationType: true},
    );

    final entity = NotificationEnableEntity(
      deviceToken: deviceToken,
      notificationType: notificationType,
    );

    try {
      if (nextValue) {
        await _repo.enable(target: target, entity: entity);
      } else {
        await _repo.disable(target: target, entity: entity);
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('[NotificationSettingViewModel.setToggle] $e\n$st');
      }

      // rollback
      state = state.copyWith(
        enabled: {...state.enabled, notificationType: !nextValue},
      );
      rethrow;
    } finally {
      state = state.copyWith(
        loading: {...state.loading, notificationType: false},
      );
    }
  }

  void setInitialEnabled(Map<String, bool> initialEnabled) {
    state = state.copyWith(
      enabled: {...state.enabled, ...initialEnabled},
    );
  }
}
