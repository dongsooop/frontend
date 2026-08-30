import 'package:dongsoop/data/home/model/home_response.dart';

abstract class HomeDataSource {
  Future<HomeResponse> fetchGuestHome({String? fid, String? deviceToken});
}
