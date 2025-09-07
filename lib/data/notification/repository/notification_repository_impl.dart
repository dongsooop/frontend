import 'package:flutter/foundation.dart';

import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/notification/data_source/notification_data_source.dart';
import 'package:dongsoop/data/notification/model/notification_response_model.dart';
import 'package:dongsoop/domain/notification/entity/notification_response_entity.dart';
import 'package:dongsoop/domain/notification/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource _dataSource;
  NotificationRepositoryImpl(this._dataSource);

  @override
  Future<NotificationResponseEntity> fetchNotificationList({
    required int page,
    required int size,
  }) {
    return _handle(
          () async {
        final NotificationResponseModel model =
        await _dataSource.fetchNotificationList(page: page, size: size);
        return model.toEntity();
      },
      NotificationListException(),
    );
  }

  @override
  Future<void> readNotification({required int id}) {
    return _handle(
          () => _dataSource.readNotification(id: id),
      NotificationReadException(),
    );
  }

  @override
  Future<void> readAllNotification() {
    return _handle(
          () => _dataSource.readAllNotification(),
      NotificationReadException(),
    );
  }

  @override
  Future<void> deleteNotification({required int id}) {
    return _handle(
          () => _dataSource.deleteNotification(id: id),
      NotificationDeleteException(),
    );
  }

  Future<T> _handle<T>(Future<T> Function() action, Exception exception) async {
    try {
      return await action();
    } catch (e, st) {
      if (kDebugMode) {
        print('[NotificationRepository] error: $e\n$st');
      }
      throw exception;
    }
  }
}