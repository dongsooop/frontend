import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:dongsoop/providers/auth_dio.dart';
import 'package:dongsoop/providers/plain_dio.dart';

import 'package:dongsoop/data/notification/data_source/notification_setting_data_source.dart';
import 'package:dongsoop/data/notification/data_source/notification_setting_data_source_impl.dart';
import 'package:dongsoop/data/notification/repository/notification_setting_repository_impl.dart';

import 'package:dongsoop/domain/notification/repository/notification_setting_repository.dart';

final notificationSettingDataSourceProvider =
Provider<NotificationSettingDataSource>((ref) {
  final authDio = ref.watch(authDioProvider);
  final plainDio = ref.watch(plainDioProvider);

  return NotificationSettingDataSourceImpl(authDio, plainDio);
});

final notificationSettingRepositoryProvider =
Provider<NotificationSettingRepository>((ref) {
  final ds = ref.watch(notificationSettingDataSourceProvider);
  return NotificationSettingRepositoryImpl(ds);
});