import 'package:dongsoop/data/device/model/device_response.dart';

abstract class DeviceDataSource {
  Future<List<DeviceResponse>> getDeviceList();
  Future<void> forceLogout(int deviceId);
}