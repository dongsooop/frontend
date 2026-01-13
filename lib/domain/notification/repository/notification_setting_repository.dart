import 'package:dongsoop/domain/notification/entity/notification_enable_entity.dart';
import 'package:dongsoop/domain/notification/entity/notification_recruit_entity.dart';
import 'package:dongsoop/domain/notification/enum/notification_target.dart';
import 'package:dongsoop/domain/notification/enum/notification_type.dart';

abstract class NotificationSettingRepository {
  Future<Map<NotificationType, bool>> fetchSettings({
    required NotificationTarget target,
    required String deviceToken,
  });

  Future<void> enable({
    required NotificationTarget target,
    required NotificationEnableEntity entity,
  });

  Future<void> disable({
    required NotificationTarget target,
    required NotificationEnableEntity entity,
  });

  Future<void> setApply({
    required NotificationTarget target,
    required NotificationRecruitEntity entity,
  });

  Future<void> setResult({
    required NotificationTarget target,
    required NotificationRecruitEntity entity,
  });
}
