import 'package:dongsoop/data/device/data_source/device_data_source.dart';
import 'package:dongsoop/domain/device/entity/device_entity.dart';
import 'package:dongsoop/domain/device/repository/device_repository.dart';
import 'package:dongsoop/domain/device_token/enum/device_type.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceDataSource _dataSource;

  DeviceRepositoryImpl(this._dataSource);

  @override
  Future<List<DeviceEntity>> getDeviceList() async {
    final models = await _dataSource.getDeviceList();

    return models.map((m) {
      return DeviceEntity(
        id: m.id,
        type: _deviceTypeFromString(m.type),
      );
    }).toList();
  }

  @override
  Future<void> forceLogout(int deviceId) async {
    await _dataSource.forceLogout(deviceId);
  }

  DeviceType _deviceTypeFromString(String raw) {
    switch (raw.toUpperCase()) {
      case 'ANDROID':
        return DeviceType.ANDROID;
      case 'IOS':
        return DeviceType.IOS;
      case 'WEB':
        return DeviceType.WEB;
      default:
        return DeviceType.UNKNOWN;
    }
  }
}