import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/restaurants/data_source/restaurants_data_source.dart';
import 'package:dio/dio.dart';
import 'package:dongsoop/domain/restaurants/model/restaurant.dart';
import 'package:dongsoop/domain/restaurants/model/restaurants_kakao_info.dart';
import 'package:dongsoop/domain/restaurants/model/restaurants_request.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RestaurantsDataSourceImpl implements RestaurantsDataSource{
  final Dio _plainDio;
  final Dio _authDio;

  RestaurantsDataSourceImpl(
    this._plainDio,
    this._authDio,
  );

  // 카카오 키워드 검색
  @override
  Future<List<RestaurantsKakaoInfo>?> searchByKakao(String search) async {
    final baseUrl = dotenv.get('KAKAO_URL');
    final restApiKey = dotenv.get('KAKAO_API_KEY');

    try {
      final dio = Dio();

      final response = await dio.get(
        baseUrl,
        queryParameters: {
          'y': 37.5002972,
          'x': 126.8680825,
          'radius': 1000,
          'query': search,
        },
        options: Options(
          headers: {
            'Authorization': 'KakaoAK $restApiKey',
          },
        ),
      );

      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data['documents'];

        final List<RestaurantsKakaoInfo> info = data.map((e) => RestaurantsKakaoInfo.fromJson(e as Map<String, dynamic>)).toList();

        return info;
      }
    } catch (e) {
      throw KaKaoSearchException();
    }
    return null;
  }

  @override
  Future<bool> checkRestaurantsDuplication(String externalMapId) async {
    final endpoint = dotenv.get('CHECK_RESTAURANTS_DUPLICATION');
    final query = 'externalMapId=${externalMapId}';

    try {
      final response = await _authDio.get(endpoint+query);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final data = response.data;

        return data['isDuplicate'];
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> restaurantsRegister(RestaurantsRequest request) async {
    final endpoint = dotenv.get('CREATE_RESTAURANTS');

    try {
      final response = await _authDio.post(endpoint, data: request.toJson());
      if (response.statusCode == HttpStatusCode.created.code) {
        return true;
      }
      return false;
    }  on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.conflict.code) {
        throw RestaurantsDuplicationException();
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Restaurant>?> getRestaurants() async {
    final endpoint = dotenv.get('RESTAURANTS');

    try {
      final response = await _authDio.get(endpoint);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data;

        final List<Restaurant> reports = data.map((e) => Restaurant.fromJson(e as Map<String, dynamic>)).toList();

        return reports;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      print('error: $e');
      rethrow;
    }
  }
}