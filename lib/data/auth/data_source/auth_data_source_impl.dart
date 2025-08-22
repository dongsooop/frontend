import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/domain/auth/model/sign_in_response.dart';
import 'package:dongsoop/domain/auth/model/sign_up_request.dart';
import 'package:dongsoop/domain/auth/model/stored_user.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
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
  Future<SignInResponse> signIn(
    String email,
    String password,
    String fcmToken,
    String deviceType,
  ) async {
    final endpoint = dotenv.get('LOGIN_ENDPOINT');
    final requestBody = {
      "email": email,
      "password": password,
      "fcmToken": fcmToken,
      "deviceType": deviceType,
    };
    try {
      final response = await _plainDio.post(endpoint, data: requestBody);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final data = response.data;

        return SignInResponse.fromJson(data);
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.badRequest.code) {
        throw InvalidCredentialsException();
      } else if (e.response?.statusCode == HttpStatusCode.forbidden.code) {
        throw UserSanctionedException();
      }
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
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> passwordReset(String email, String password) async {
    final endpoint = dotenv.get('PW_RESET_ENDPOINT');
    final requestBody = {"email": email, "password": password};

    try {
      final response = await _plainDio.post(endpoint, data: requestBody);
      if (response.statusCode == HttpStatusCode.noContent.code) {
        return true;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> passwordSendEmailCode(String userEmail) async {
    final endpoint = dotenv.get('PW_SEND_EMAIL_ENDPOINT');
    final requestBody = {"userEmail": userEmail};

    try {
      final response = await _plainDio.post(endpoint, data: requestBody);
      if (response.statusCode == HttpStatusCode.noContent.code) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.badRequest.code) {
        return false;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> passwordCheckEmailCode(String userEmail, String code) async {
    final endpoint = dotenv.get('PW_CHECK_CODE_ENDPOINT');
    final requestBody = {"userEmail": userEmail, "code": code};

    try {
      final response = await _plainDio.post(endpoint, data: requestBody);
      if (response.statusCode == HttpStatusCode.noContent.code) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.badRequest.code) {
        return false;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    final endpoint = dotenv.get('LOGOUT_ENDPOINT');
    final fcmToken = await _secureStorageService.read('fcmToken');

    final headers = <String, String>{
      if (fcmToken?.isNotEmpty == true) 'Device-Token': fcmToken!,
    };

    try {
      await _authDio.post(
        endpoint,
        options: Options(
          headers: headers,
          followRedirects: false,
          validateStatus: (s) => s == HttpStatusCode.redirect.code,
        ),
      );
    } on DioException {
      throw LogoutException();
    } finally {
      await _preferencesService.clearUser();
      await _secureStorageService.delete();
    }
  }

  @override
  Future<bool> deleteUser() async {
    final endpoint = dotenv.get('DELETE_USER_ENDPOINT');
    try {
      await _authDio.delete(endpoint);
      await _secureStorageService.deleteFcmToken(); // 회원 탈퇴시 fcm 토큰 삭제
      return true;
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
    await _preferencesService.saveUser(
      User(
        id: storedUser.id,
        nickname: storedUser.nickname,
        departmentType: storedUser.departmentType,
        role: storedUser.role,
      )
    );
    await _secureStorageService.write('accessToken', storedUser.accessToken);
    await _secureStorageService.write('refreshToken', storedUser.refreshToken);
  }

  @override
  Future<bool> checkEmailCode(String userEmail, String code) async {
    final endpoint = dotenv.get('CHECK_CODE_ENDPOINT');
    final requestBody = {"userEmail": userEmail, "code": code};
    try {
      final response = await _plainDio.post(endpoint, data: requestBody);
      if (response.statusCode == HttpStatusCode.noContent.code) {
        return true;
      }
      return false;
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.badRequest.code) {
        return false;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> sendEmailCode(String userEmail) async {
    final endpoint = dotenv.get('SEND_EMAIL_ENDPOINT');
    final requestBody = {"userEmail": userEmail};
    try {
      final response = await _plainDio.post(endpoint, data: requestBody);
      if (response.statusCode == HttpStatusCode.noContent.code) {
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> userBlock(int blockerId, int blockedMemberId) async {
    final endpoint = dotenv.get('BLOCK_ENDPOINT');
    final requestBody = {"blockerId": blockerId, "blockedMemberId": blockedMemberId};
    
    try {
      await _authDio.post(endpoint, data: requestBody);
    } catch (e) {
      rethrow;
    }
  }
}
