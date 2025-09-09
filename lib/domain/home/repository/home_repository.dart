import 'package:dongsoop/domain/home/entity/home_entity.dart';

abstract class HomeRepository {
  Future<HomeEntity> fetchHome({required String departmentType});
  Future<HomeEntity> fetchGuestHome();
}
