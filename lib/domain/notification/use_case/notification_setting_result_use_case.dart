import 'package:dongsoop/domain/notification/entity/notification_recruit_entity.dart';
import 'package:dongsoop/domain/notification/enum/notification_target.dart';
import 'package:dongsoop/domain/notification/repository/notification_setting_repository.dart';

class NotificationSettingResultUseCase {
  final NotificationSettingRepository _repository;

  NotificationSettingResultUseCase(this._repository);

  Future<void> execute({
    required NotificationTarget target,
    required NotificationRecruitEntity entity,
  }) {
    return _repository.setResult(
      target: target,
      entity: entity,
    );
  }
}