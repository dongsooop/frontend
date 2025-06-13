import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/domain/auth/model/login_response.dart';
import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:dongsoop/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'auth_data_source.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final Dio _plainDio;
  final SecureStorageService _secureStorageService;
  final PreferencesService _preferencesService;

  AuthDataSourceImpl(
    this._plainDio,
    this._secureStorageService,
    this._preferencesService,
  );

  @override
  Future<LoginResponse> login(String email, String password) async {
    final endpoint = dotenv.get('LOGIN_ENDPOINT');
    final requestBody = {"email": email, "password": password};

    try {
      final response = await _plainDio.post(endpoint, data: requestBody);
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
    // token 삭제
    _secureStorageService.delete();
  }

  @override
  Future<User?> getUser() {
    return _preferencesService.getUser();
  }

  @override
  Future<void> saveUser(StoredUser storedUser) async {
    // 닉네임, 학과 저장
    await _preferencesService.saveUser(User(
        id: storedUser.id,
        nickname: storedUser.nickname,
        departmentType: storedUser.departmentType));
    // token 저장
    await _secureStorageService.write('accessToken', storedUser.accessToken);
    await _secureStorageService.write('refreshToken', storedUser.refreshToken);
  }
}
