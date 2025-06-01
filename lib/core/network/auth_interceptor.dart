import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/providers/auth_providers.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorageService;
  final PreferencesService _preferencesService;
  final Ref _ref;

  AuthInterceptor(
    this._secureStorageService,
    this._preferencesService,
    this._ref,
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
      logger.i("401: AccessToken 만료");
      try {
        final refreshDio = Dio();
        final baseUrl = dotenv.get('BASE_URL');
        final endpoint = dotenv.get('REISSUE_ENDPOINT');
        final url = '$baseUrl$endpoint';

        final refreshResponse = await refreshDio.get(url);

        final newAccessToken = refreshResponse.data.toString();
        logger.i("AccessToken 발급: $newAccessToken");
        await _secureStorageService.write('accessToken', newAccessToken);

        final originalRequest = err.requestOptions;
        originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await Dio().request(
          originalRequest.path,
          options: Options(
            method: originalRequest.method,
            headers: originalRequest.headers
          ),
          data: originalRequest.data,
          queryParameters: originalRequest.queryParameters
        );

        return handler.resolve(retryResponse);
      }  on DioException catch (e) {
        if (e.response?.statusCode == HttpStatusCode.unauthorized.code) {
          logger.w('🔓 RefreshToken 만료, 로그아웃 처리');
          await _secureStorageService.delete('accessToken');
          await _preferencesService.clearUser();
          _ref.read(userSessionProvider.notifier).state = null;

          throw ReIssueException();
        }
        return handler.reject(e);
      }
    }
    super.onError(err, handler);
  }
}