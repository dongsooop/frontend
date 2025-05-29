import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/auth/data_source/auth_data_source.dart';
import 'package:dongsoop/domain/auth/model/login_response.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RemoteAuthDataSourceImpl implements AuthDataSource {
  final Dio dio;
  RemoteAuthDataSourceImpl(this.dio);

  @override
  Future<LoginResponse> login(String email, String password) async {
    final baseUrl = dotenv.get('BASE_URL');
    final endpoint = dotenv.get('LOGIN_ENDPOINT');
    final url = '$baseUrl$endpoint';
    final requestBody = {
      "email": email,
      "password": password
    };

    try {
      final response = await dio.post(url, data: requestBody);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final data = response.data;
        logger.i('Login Response data: $data');

        return LoginResponse.fromJson(data);
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.badRequest.code) {
        throw LoginException();
      }
      logger.e("Login error", error: e);
      rethrow;
    } catch (e, st) {
      logger.e("Login error", error: e, stackTrace: st);
      rethrow;
    }
  }
}