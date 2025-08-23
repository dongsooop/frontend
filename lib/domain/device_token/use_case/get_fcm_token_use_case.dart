import 'package:dongsoop/domain/device_token/repositoy/device_token_repository.dart';

// 현재 사용 가능한 FCM 토큰 1회 조회
class GetFcmTokenUseCase {
  final DeviceTokenRepository _deviceRepo;
  GetFcmTokenUseCase(this._deviceRepo);

  Future<String?> execute() => _deviceRepo.getFcmToken();
}
