import 'package:dongsoop/domain/device/entity/device_entity.dart';
import 'package:dongsoop/domain/device/repository/device_repository.dart';

class DeviceListUseCase {
  final DeviceRepository _repository;

  DeviceListUseCase(this._repository);

  Future<List<DeviceEntity>> execute() {
    return _repository.getDeviceList();
  }
}