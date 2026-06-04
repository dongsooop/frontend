import 'package:dongsoop/data/home/model/home_response.dart';

abstract class HomeDataSource {
  Future<HomeResponse> fetchHome({required String departmentType});
  Future<HomeResponse> fetchGuestHome();
}