import 'package:dongsoop/data/notification/data_source/os_notification_data_source.dart';
import 'package:dongsoop/data/notification/repository/os_notification_repository_impl.dart';
import 'package:dongsoop/domain/notification/repository/os_notification_repository.dart';
import 'package:dongsoop/domain/notification/use_case/os_notification_allow_use_case.dart';
import 'package:dongsoop/domain/notification/use_case/os_notification_permission_use_case.dart';
import 'package:dongsoop/domain/notification/use_case/os_notification_setting_use_case.dart';
import 'package:dongsoop/presentation/setting/os_notification_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final osNotificationDsProvider = Provider((ref) => OsNotificationDataSource());

// Repo
final notificationPermissionRepositoryProvider =
Provider<OsNotificationRepository>(
      (ref) => OsNotificationRepositoryImpl(ref.read(osNotificationDsProvider)),
);

// UseCases
final getOsAllowedUseCaseProvider = Provider(
      (ref) => OsNotificationAllowUseCase(ref.read(notificationPermissionRepositoryProvider)),
);

final requestOsPermissionUseCaseProvider = Provider(
      (ref) => OsNotificationPermissionUseCase(ref.read(notificationPermissionRepositoryProvider)),
);

final openOsSettingsUseCaseProvider = Provider(
      (ref) => OsNotificationSettingsUseCase(ref.read(notificationPermissionRepositoryProvider)),
);

// VM
final osNotificationViewModelProvider =
StateNotifierProvider<OsNotificationViewModel, OsNotificationState>(
      (ref) => OsNotificationViewModel(ref),
);