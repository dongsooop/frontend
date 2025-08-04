import 'package:dongsoop/domain/board/timezone/repository/check_time_zone_repository.dart';

class CheckTimeZoneUseCase {
  final CheckTimeZoneRepository timeZoneRepository;

  CheckTimeZoneUseCase(this.timeZoneRepository);

  Future<bool> isUserTimezone() async {
    final tz = await timeZoneRepository.getDeviceTimeZone();
    return tz == 'Asia/Seoul';
  }
}
