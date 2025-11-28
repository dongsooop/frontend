import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/restaurants/data_source/restaurants_data_source.dart';
import 'package:dio/dio.dart';
import 'package:dongsoop/domain/restaurants/enum/restaurants_category.dart';
import 'package:dongsoop/domain/restaurants/enum/restaurants_tag.dart';
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
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.conflict.code) {
        throw RestaurantsDuplicationException();
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Restaurant>?> getRestaurants({
    required bool isLogin,
    RestaurantsCategory? category,
    required int page,
    int size = 20,
  }) async {
    final endpoint = dotenv.get('RESTAURANTS');
    final queryParams = {
      'page': page,
      'size': size,
      if (category != null) 'category': category.apiValue,
    };

    try {
      final response = isLogin
      ? await _authDio.get(
          endpoint,
          queryParameters: queryParams,
        )
      : await _plainDio.get(
          endpoint,
          queryParameters: queryParams,
        );
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

  @override
  Future<bool> like({
    required int id,
    required bool likedByMe,
  }) async {
    final restaurant = dotenv.get('RESTAURANT');
    final like = dotenv.get('RESTAURANT_LIKE');
    final endpoint = restaurant + '/$id' + like;

    try {
      final response = await _authDio.post(
        endpoint,
        queryParameters: {
          'isAdding': !likedByMe,
        },
      );
      if (response.statusCode == HttpStatusCode.ok.code) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Restaurant>?> search({
    required bool isLogin,
    required String search,
    required int page,
    int size = 20,
  }) async {
    final endpoint = dotenv.get('RESTAURANTS_SEARCH');
    final queryParams = {
      'page': page,
      'size': size,
      'keyword': search,
    };

    try {
      final response = isLogin
        ? await _authDio.get(
            endpoint,
            queryParameters: queryParams,
          )
        : await _plainDio.get(
            endpoint,
            queryParameters: queryParams,
          );

      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data['results'];

        final List<Restaurant> reports = data.map((e) {
          final json = Map<String, dynamic>.from(e as Map<String, dynamic>);

          final tagsDynamic = json['tags'] as List<dynamic>?;
          final tags = tagsDynamic
              ?.map((t) => _tagFromString(t as String))
              .whereType<RestaurantsTag>()
              .toList();

          json['tags'] = tags?.map((t) => t.name).toList();

          return Restaurant.fromJson(json);
        }).toList();

        return reports;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      print('error: $e');
      rethrow;
    }
  }

  RestaurantsTag? _tagFromString(String value) {
    try {
      return RestaurantsTag.values.byName(value);
    } catch (_) {
      try {
        return RestaurantsTag.values.firstWhere(
          (tag) => tag.label == value,
        );
      } catch (_) {
        return null;
      }
    }
  }
}