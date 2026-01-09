import 'package:dongsoop/domain/notification/enum/notification_target.dart';
import 'package:dongsoop/domain/notification/enum/notification_type.dart';
import 'package:dongsoop/domain/notification/repository/notification_setting_repository.dart';

class NotificationSettingUseCase {
  final NotificationSettingRepository _repo;
  NotificationSettingUseCase(this._repo);

  Future<Map<NotificationType, bool>> execute({
    required NotificationTarget target,
    required String deviceToken,
  }) {
    return _repo.fetchSettings(
      target: target,
      deviceToken: deviceToken,
    );
  }
}