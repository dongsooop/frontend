import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/domain/auth/model/sign_in_response.dart';
import 'package:dongsoop/domain/auth/model/sign_up_request.dart';
import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:dongsoop/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  Future<SignInResponse> signIn(String email, String password) async {
    final endpoint = dotenv.get('LOGIN_ENDPOINT');
    final requestBody = {"email": email, "password": password};

    try {
      final response = await _plainDio.post(endpoint, data: requestBody);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final data = response.data;
        logger.i('Login Response data: $data');

        return SignInResponse.fromJson(data);
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.badRequest.code) {
        throw InvalidCredentialsException();
      } else if (e.response?.statusCode == HttpStatusCode.forbidden.code) {
        throw UserSanctionedException();
      }
      logger.e("Login error statusCode: ${e.response?.statusCode}");
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signUp(SignUpRequest request) async {
    final endpoint = dotenv.get('SIGNUP_ENDPOINT');
    try {
      await _plainDio.post(endpoint, data: request.toJson());
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.badRequest.code) {
        throw SignUpException();
      }
      logger.e("Sign up error statusCode: ${e.response?.statusCode}");
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> validate(String data, String type) async {
    final endpoint;
    if (type == 'email') endpoint = dotenv.get('EMAIL_VALIDATE_ENDPOINT');
    else endpoint = dotenv.get('NICKNAME_VALIDATE_ENDPOINT');

    final requestBody = {
      type: data
    };

    try {
      final response = await _plainDio.post(endpoint, data: requestBody);
      if (response.statusCode == HttpStatusCode.noContent.code) {
        return false;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.conflict.code) {
        return true;
      }
      logger.e("Sign up error statusCode: ${e.response?.statusCode}");
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    // 닉네임, 학과, id 삭제
    await _preferencesService.clearUser();
    // token 삭제
    await _secureStorageService.delete();
  }

  @override
  Future<bool> deleteUser() async {
    final endpoint = dotenv.get('DELETE_USER_ENDPOINT');
    try {
      await _authDio.delete(endpoint);
      logger.i('delete user');
      return true;
    } on DioException catch (e) {
      logger.e("delete user error statusCode: ${e.response?.statusCode}");
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> getUser() {
    return _preferencesService.getUser();
  }

  @override
  Future<void> saveUser(StoredUser storedUser) async {
    // 닉네임, 학과 저장
    await _preferencesService.saveUser(
      User(
        id: storedUser.id,
        nickname: storedUser.nickname,
        departmentType: storedUser.departmentType,
        role: storedUser.role,
      )
    );
    // token 저장
    await _secureStorageService.write('accessToken', storedUser.accessToken);
    await _secureStorageService.write('refreshToken', storedUser.refreshToken);
  }
}
