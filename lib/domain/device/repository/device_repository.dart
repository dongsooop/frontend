import 'package:dongsoop/domain/device/entity/device_entity.dart';

abstract class DeviceRepository {
  Future<List<DeviceEntity>> getDeviceList();
  Future<void> forceLogout(int deviceId);
}