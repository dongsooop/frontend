import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/cafeteria/data_sources/cafeteria_data_source.dart';
import 'package:dongsoop/data/cafeteria/model/cafeteria_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CafeteriaDataSourceImpl implements CafeteriaDataSource {
  final Dio _plainDio;

  CafeteriaDataSourceImpl(this._plainDio);

  @override
  Future<CafeteriaResponse> fetchCafeteriaMeals() async {
    final endpoint = dotenv.get('CAFETERIA_ENDPOINT');

    print('[CafeteriaDataSource] 서버에 식단 요청 보냄 → $endpoint');

    final response = await _plainDio.get(endpoint);

    if (response.statusCode == HttpStatusCode.ok.code) {
      print('[CafeteriaDataSource] 응답 수신 완료');
      return CafeteriaResponse.fromJson(response.data);
    } else {
      print('[CafeteriaDataSource] 실패 응답: ${response.statusCode}');
      throw Exception('식단 조회 실패: ${response.statusCode}');
    }
  }
}
