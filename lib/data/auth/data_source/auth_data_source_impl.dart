import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/domain/auth/model/login_response.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/storage/secure_storage_service.dart';
import 'auth_data_source.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final Dio _plainDio;
  final Dio _authDio;
  final SecureStorageService _secureStorageService;
  final PreferencesService _preferencesService;

  AuthDataSourceImpl(
    this._plainDio,
    this._authDio,
    this._secureStorageService,
    this._preferencesService,
  );

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
      final response = await _plainDio.post(url, data: requestBody);
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
      logger.e("Login error statusCode: ${e.response?.statusCode}");
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    // 닉네임, 학과 삭제
    _preferencesService.clearUser();
    // accessToken 삭제
    _secureStorageService.delete('accessToken');
  }

  @override
  Future<User?> getUser() {
    return _preferencesService.getUser();
  }

  @override
  Future<void> saveUser(String nickname, String departmentType, String accessToken) async {
    // 닉네임, 학과 저장
    _preferencesService.saveUser(User(nickname: nickname, departmentType: departmentType));
    // accessToken 저장
    _secureStorageService.write('accessToken', accessToken);
  }

  @override
  Future<void> tokenTest() async {
    final baseUrl = dotenv.get('BASE_URL');
    final endpoint = dotenv.get('CHATROOMS_ENDPOINT');
    final url = '$baseUrl$endpoint';

    try {
      final response = await _authDio.get(url);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final data = response.data;
        logger.i('token Test Response data: ${data.toString()}');
      } else {
        throw Exception('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      logger.e("token Test statusCode: ${e.response?.statusCode}");
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}