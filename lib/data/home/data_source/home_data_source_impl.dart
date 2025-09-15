import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/home/model/home_response.dart';
import 'home_data_source.dart';

class HomeDataSourceImpl implements HomeDataSource {
  final Dio _authDio;
  final Dio _plainDio;

  HomeDataSourceImpl(this._authDio, this._plainDio);

  @override
  Future<HomeResponse> fetchHome({required String departmentType}) async {
    final base = dotenv.get('HOME_ENDPOINT');
    final url = '$base/$departmentType';

    final response = await _authDio.get(url);
    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const FormatException('응답이 Map<String, dynamic> 형식이 아닙니다.');
      }
      return HomeResponse.fromJson(data);
    }
    throw Exception('status: ${response.statusCode}');
  }

  @override
  Future<HomeResponse> fetchGuestHome() async {
    final url = dotenv.get('HOME_ENDPOINT');

    final response = await _plainDio.get(url);
    if (response.statusCode == HttpStatusCode.ok.code) {
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const FormatException('응답이 Map<String, dynamic> 형식이 아닙니다.');
      }
      return HomeResponse.fromJson(data);
    }
    throw Exception('status: ${response.statusCode}');
  }
}
