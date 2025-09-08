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
  Future<HomeResponse> fetchHome() async {
    final url = dotenv.get('HOME_ENDPOINT');
    return _fetch(_authDio, url);
  }

  @override
  Future<HomeResponse> fetchGuestHome() async {
    final url = dotenv.get('HOME_ENDPOINT');
    return _fetch(_plainDio, url);
  }

  Future<HomeResponse> _fetch(Dio dio, String url) async {
    final res = await dio.get(url);

    if (res.statusCode == HttpStatusCode.ok.code) {
      final data = res.data;
      if (data is! Map<String, dynamic>) {
        throw const FormatException('응답이 Map<String, dynamic> 형식이 아닙니다.');
      }
      return HomeResponse.fromJson(data);
    }

    throw Exception('Unexpected status: ${res.statusCode}');
  }
}
