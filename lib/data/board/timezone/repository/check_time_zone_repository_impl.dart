import 'package:dongsoop/domain/board/timezone/repository/check_time_zone_repository.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class CheckTimeZoneRepositoryImpl implements CheckTimeZoneRepository {
  @override
  Future<String> getDeviceTimeZone() async {
    final timezone = await FlutterTimezone.getLocalTimezone();
    return timezone;
  }
}
