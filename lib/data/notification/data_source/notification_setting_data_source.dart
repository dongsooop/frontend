import 'package:dongsoop/data/notification/model/notification_enable_model.dart';
import 'package:dongsoop/data/notification/model/notification_recruit_model.dart';
import 'package:dongsoop/domain/notification/enum/notification_target.dart';

abstract class NotificationSettingDataSource {
  Future<Map<String, dynamic>> fetchSettings({
    required NotificationTarget target,
    required String deviceToken,
  });

  Future<void> enable({
    required NotificationTarget target,
    required NotificationEnableModel body,
  });

  Future<void> disable({
    required NotificationTarget target,
    required NotificationEnableModel body,
  });

  Future<void> setApply({
    required NotificationTarget target,
    required NotificationRecruitModel body,
  });

  Future<void> setResult({
    required NotificationTarget target,
    required NotificationRecruitModel body,
  });
}