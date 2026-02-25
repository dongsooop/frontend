import 'package:dongsoop/domain/device_token/enum/device_type.dart';

class DeviceEntity {
  final int id;
  final DeviceType type;
  final bool current;

  const DeviceEntity({
    required this.id,
    required this.type,
    required this.current,
  });
}