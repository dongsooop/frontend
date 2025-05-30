import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/providers/secure_storage_provider.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorageService;
  final AuthRepository _authRepository;

  AuthInterceptor(
    this._secureStorageService,
    this._authRepository,
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // AccessToken read
      final accessToken = await _secureStorageService.read('accessToken');
      // header에 AccessToken 포함
      options.headers['Authorization'] = 'Bearer $accessToken';
      logger.i('➡️ [AUTH] ${options.method} ${options.uri}');
    } catch (e) {
      logger.e('AuthInterceptor error: $e');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i('✅ [AUTH] ${response.statusCode} ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    logger.e('❌ [AUTH] Error: ${err.response?.statusCode} ${err.message}');
    // AccessToken 만료(401)
    if (err.response?.statusCode == HttpStatusCode.unauthorized.code) {


    }

    super.onError(err, handler);
  }
}

// refreshDio
// Future<Dio> reissueDio(SecureStorageService _secureStorageService, AuthRepository _authRepository) async {
//   final dio = Dio();
//   // AccessToken read
//   final accessToken = await _secureStorageService.read('accessToken');
//
//   dio.interceptors.clear();
//   dio.interceptors.add(InterceptorsWrapper(
//     onError: (err, handler) async {
//       // refreshToken 만료(401)
//       if (err.response?.statusCode == HttpStatusCode.unauthorized.code) {
//         // user local data delete
//         await _authRepository.clearUser();
//         await _secureStorageService.delete("accessToken");
//       }
//       return handler.next(err);
//     }
//   ));
//
//
// }