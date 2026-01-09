import 'package:dongsoop/domain/notification/entity/notification_recruit_entity.dart';
import 'package:dongsoop/domain/notification/enum/notification_target.dart';
import 'package:dongsoop/domain/notification/repository/notification_setting_repository.dart';

class NotificationSettingApplyUseCase {
  final NotificationSettingRepository _repository;

  NotificationSettingApplyUseCase(this._repository);

  Future<void> execute({
    required NotificationTarget target,
    required NotificationRecruitEntity entity,
  }) {
    return _repository.setApply(
      target: target,
      entity: entity,
    );
  }
}