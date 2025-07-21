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

    final response = await _plainDio.get(endpoint);

    if (response.statusCode == HttpStatusCode.ok.code) {
      return CafeteriaResponse.fromJson(response.data);
    } else {
      throw Exception('식단 조회 실패: ${response.statusCode}');
    }
  }
}
