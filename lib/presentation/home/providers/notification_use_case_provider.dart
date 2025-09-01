import 'package:dongsoop/data/notification/data_source/notification_data_source_impl.dart';
import 'package:dongsoop/data/notification/repository/notification_repository_impl.dart';
import 'package:dongsoop/domain/notification/use_case/notification_delete_use_case.dart';
import 'package:dongsoop/domain/notification/use_case/notification_list_use_case.dart';
import 'package:dongsoop/domain/notification/use_case/notification_read_use_case.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationDataSourceProvider = Provider(
      (ref) => NotificationDataSourceImpl(ref.watch(authDioProvider)),
);

final notificationRepositoryProvider = Provider(
      (ref) => NotificationRepositoryImpl(ref.watch(notificationDataSourceProvider)),
);

final notificationUseCaseProvider = Provider<NotificationListUseCase>((ref) {
  final repository = ref.read(notificationRepositoryProvider);
  return NotificationListUseCase(repository);
});

final notificationReadUseCaseProvider = Provider<NotificationReadUseCase>((ref) {
  final repository = ref.read(notificationRepositoryProvider);
  return NotificationReadUseCase(repository);
});

final notificationDeleteUseCaseProvider = Provider<NotificationDeleteUseCase>((ref) {
  final repository = ref.read(notificationRepositoryProvider);
  return NotificationDeleteUseCase(repository);
});
