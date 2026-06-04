import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dongsoop/domain/notification/use_case/notification_disable_use_case.dart';
import 'package:dongsoop/domain/notification/use_case/notification_enable_use_case.dart';
import 'package:dongsoop/domain/notification/use_case/notification_setting_use_case.dart';
import 'package:dongsoop/domain/notification/use_case/notification_setting_apply_use_case.dart';
import 'package:dongsoop/domain/notification/use_case/notification_setting_result_use_case.dart';

import 'package:dongsoop/presentation/setting/notification/providers/notification_setting_provider.dart';

final notificationSettingUseCaseProvider =
Provider<NotificationSettingUseCase>((ref) {
  final repo = ref.watch(notificationSettingRepositoryProvider);
  return NotificationSettingUseCase(repo);
});

final notificationEnableUseCaseProvider =
Provider<NotificationEnableUseCase>((ref) {
  final repo = ref.watch(notificationSettingRepositoryProvider);
  return NotificationEnableUseCase(repo);
});

final notificationDisableUseCaseProvider =
Provider<NotificationDisableUseCase>((ref) {
  final repo = ref.watch(notificationSettingRepositoryProvider);
  return NotificationDisableUseCase(repo);
});

final notificationSettingApplyUseCaseProvider =
Provider<NotificationSettingApplyUseCase>((ref) {
  final repo = ref.watch(notificationSettingRepositoryProvider);
  return NotificationSettingApplyUseCase(repo);
});

final notificationSettingResultUseCaseProvider =
Provider<NotificationSettingResultUseCase>((ref) {
  final repo = ref.watch(notificationSettingRepositoryProvider);
  return NotificationSettingResultUseCase(repo);
});