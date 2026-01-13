import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/notification/data_source/notification_setting_data_source.dart';
import 'package:dongsoop/data/notification/model/notification_enable_model.dart';
import 'package:dongsoop/data/notification/model/notification_recruit_model.dart';

import 'package:dongsoop/domain/notification/entity/notification_enable_entity.dart';
import 'package:dongsoop/domain/notification/entity/notification_recruit_entity.dart';
import 'package:dongsoop/domain/notification/enum/notification_target.dart';
import 'package:dongsoop/domain/notification/enum/notification_type.dart';
import 'package:dongsoop/domain/notification/repository/notification_setting_repository.dart';

class NotificationSettingRepositoryImpl implements NotificationSettingRepository {
  final NotificationSettingDataSource _dataSource;

  NotificationSettingRepositoryImpl(this._dataSource);

  NotificationEnableModel _mapEnableBody(NotificationEnableEntity entity) {
    return NotificationEnableModel(
      deviceToken: entity.deviceToken,
      notificationType: entity.notificationType,
    );
  }

  NotificationRecruitModel _mapRecruitBody(NotificationRecruitEntity entity) {
    return NotificationRecruitModel(
      deviceToken: entity.deviceToken,
      targetState: entity.targetState,
    );
  }

  Map<NotificationType, bool> _mapSettings(Map<String, dynamic> json) {
    final result = <NotificationType, bool>{};

    json.forEach((key, value) {
      final type = NotificationType.fromCode(key);
      result[type] = value as bool;
    });

    return result;
  }

  @override
  Future<Map<NotificationType, bool>> fetchSettings({
    required NotificationTarget target,
    required String deviceToken,
  }) {
    return _handle(
          () async {
        final json = await _dataSource.fetchSettings(
          target: target,
          deviceToken: deviceToken,
        );
        return _mapSettings(json);
      },
      NotificationSettingException(),
    );
  }

  @override
  Future<void> enable({
    required NotificationTarget target,
    required NotificationEnableEntity entity,
  }) {
    return _handle(
          () => _dataSource.enable(
        target: target,
        body: _mapEnableBody(entity),
      ),
      NotificationSettingException(),
    );
  }

  @override
  Future<void> disable({
    required NotificationTarget target,
    required NotificationEnableEntity entity,
  }) {
    return _handle(
          () => _dataSource.disable(
        target: target,
        body: _mapEnableBody(entity),
      ),
      NotificationSettingException(),
    );
  }

  @override
  Future<void> setApply({
    required NotificationTarget target,
    required NotificationRecruitEntity entity,
  }) {
    return _handle(
          () => _dataSource.setApply(
        target: target,
        body: _mapRecruitBody(entity),
      ),
      NotificationSettingException(),
    );
  }

  @override
  Future<void> setResult({
    required NotificationTarget target,
    required NotificationRecruitEntity entity,
  }) {
    return _handle(
          () => _dataSource.setResult(
        target: target,
        body: _mapRecruitBody(entity),
      ),
      NotificationSettingException(),
    );
  }

  Future<T> _handle<T>(
      Future<T> Function() action,
      Exception exception,
      ) async {
    try {
      return await action();
    } catch (_) {
      throw exception;
    }
  }
}
