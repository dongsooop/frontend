import 'package:dongsoop/domain/home/entity/home_entity.dart';

abstract class HomeRepository {
  Future<HomeEntity> fetchGuestHome({String? fid, String? deviceToken});
}
