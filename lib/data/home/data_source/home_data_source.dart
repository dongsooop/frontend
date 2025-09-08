import 'package:dongsoop/data/home/model/home_response.dart';

abstract class HomeDataSource {
  Future<HomeResponse> fetchHome();
  Future<HomeResponse> fetchGuestHome();
}
