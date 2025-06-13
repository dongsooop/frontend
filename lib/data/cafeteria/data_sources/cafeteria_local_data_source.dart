import 'package:dongsoop/data/cafeteria/model/cafeteria_response.dart';

abstract class CafeteriaLocalDataSource {
  Future<void> cacheCafeteria(CafeteriaResponse response);
  Future<CafeteriaResponse?> getCachedCafeteria();
  Future<void> clearCacheCafeteria();
}
