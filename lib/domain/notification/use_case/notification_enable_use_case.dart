import 'package:dongsoop/domain/notification/entity/notification_enable_entity.dart';
import 'package:dongsoop/domain/notification/enum/notification_target.dart';
import 'package:dongsoop/domain/notification/repository/notification_setting_repository.dart';

class NotificationEnableUseCase {
  final NotificationSettingRepository _repository;
  NotificationEnableUseCase(this._repository);

  Future<void> execute({
    required NotificationTarget target,
    required String deviceToken,
    required String notificationType,
  }) {
    final entity = NotificationEnableEntity(
      deviceToken: deviceToken,
      notificationType: notificationType,
    );

    return _repository.enable(
      target: target,
      entity: entity,
    );
  }
}