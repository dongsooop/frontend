import 'package:dongsoop/domain/home/entity/home_entity.dart';

abstract class HomeRepository {
  Future<HomeEntity> fetchHome({
    String? departmentCode,
    String? fid,
    String? deviceToken,
  });
}
