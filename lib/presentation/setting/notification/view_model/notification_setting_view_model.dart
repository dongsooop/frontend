import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:dongsoop/presentation/setting/notification/providers/notification_setting_provider.dart';

import 'package:dongsoop/domain/notification/entity/notification_enable_entity.dart';
import 'package:dongsoop/domain/notification/entity/notification_recruit_entity.dart';
import 'package:dongsoop/domain/notification/enum/notification_target.dart';
import 'package:dongsoop/domain/notification/repository/notification_setting_repository.dart';

import 'notification_setting_state.dart';
import 'notification_types.dart';

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

  Future<void> setRecruitApplyToggle({
    required NotificationTarget target,
    required String deviceToken,
    required bool nextValue,
  }) async {
    final types = NotificationTypes.recruitApplyGroup;
    if (types.any(state.isLoading)) return;

    final prev = {
      for (final t in types) t: state.isEnabled(t),
    };

    final nextEnabled = {...state.enabled};
    final nextLoading = {...state.loading};
    for (final t in types) {
      nextEnabled[t] = nextValue;
      nextLoading[t] = true;
    }

    state = state.copyWith(
      enabled: nextEnabled,
      loading: nextLoading,
    );

    try {
      await _repo.setApply(
        target: target,
        entity: NotificationRecruitEntity(
          deviceToken: deviceToken,
          targetState: nextValue,
        ),
      );
    } catch (e, st) {
      if (kDebugMode) {
        print('[NotificationSettingViewModel.setRecruitApplyToggle] $e\n$st');
      }

      final rollback = {...state.enabled};
      for (final t in types) {
        rollback[t] = prev[t] ?? false;
      }

      state = state.copyWith(enabled: rollback);
      rethrow;
    } finally {
      final doneLoading = {...state.loading};
      for (final t in types) {
        doneLoading[t] = false;
      }
      state = state.copyWith(loading: doneLoading);
    }
  }

  Future<void> setRecruitResultToggle({
    required NotificationTarget target,
    required String deviceToken,
    required bool nextValue,
  }) async {
    final types = NotificationTypes.recruitResultGroup;
    if (types.any(state.isLoading)) return;

    final prev = {
      for (final t in types) t: state.isEnabled(t),
    };

    final nextEnabled = {...state.enabled};
    final nextLoading = {...state.loading};
    for (final t in types) {
      nextEnabled[t] = nextValue;
      nextLoading[t] = true;
    }

    state = state.copyWith(
      enabled: nextEnabled,
      loading: nextLoading,
    );

    try {
      await _repo.setResult(
        target: target,
        entity: NotificationRecruitEntity(
          deviceToken: deviceToken,
          targetState: nextValue,
        ),
      );
    } catch (e, st) {
      if (kDebugMode) {
        print('[NotificationSettingViewModel.setRecruitResultToggle] $e\n$st');
      }

      final rollback = {...state.enabled};
      for (final t in types) {
        rollback[t] = prev[t] ?? false;
      }

      state = state.copyWith(enabled: rollback);
      rethrow;
    } finally {
      final doneLoading = {...state.loading};
      for (final t in types) {
        doneLoading[t] = false;
      }
      state = state.copyWith(loading: doneLoading);
    }
  }

  void setInitialEnabled(Map<String, bool> initialEnabled) {
    state = state.copyWith(
      enabled: {...state.enabled, ...initialEnabled},
    );
  }
}