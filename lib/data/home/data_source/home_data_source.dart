import 'package:dongsoop/data/home/model/home_response.dart';

abstract class HomeDataSource {
  Future<HomeResponse> fetchHome({String? fid, String? deviceToken});
}
