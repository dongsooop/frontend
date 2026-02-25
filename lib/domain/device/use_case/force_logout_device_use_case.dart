import 'package:dongsoop/domain/device/repository/device_repository.dart';

class ForceLogoutDeviceUseCase {
  final DeviceRepository _repository;

  ForceLogoutDeviceUseCase(this._repository);

  Future<void> execute(int deviceId) {
    return _repository.forceLogout(deviceId);
  }
}