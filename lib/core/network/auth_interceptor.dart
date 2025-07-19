import 'package:dio/dio.dart';
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
    if (err.response?.statusCode == HttpStatusCode.unauthorized.code) {
      logger.i("401: AccessToken 만료");
      try {
        final refreshToken = await _secureStorageService.read('refreshToken');
        final refreshDio = Dio();
        final baseUrl = dotenv.get('BASE_URL');
        final endpoint = dotenv.get('REISSUE_ENDPOINT');
        final url = '$baseUrl$endpoint';

        final refreshResponse = await refreshDio.post(url, data: refreshToken);
        logger.i("refresh: ${refreshResponse.data['accessToken']} / ${refreshResponse.data['refreshToken']}");
        final newAccessToken = refreshResponse.data['accessToken'].toString();
        final newRefreshToken = refreshResponse.data['refreshToken'].toString();
        await _secureStorageService.write('accessToken', newAccessToken);
        await _secureStorageService.write('refreshToken', newRefreshToken);
        logger.i('reissue token: $newRefreshToken / $newRefreshToken');
        final originalRequest = err.requestOptions;
        originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await Dio(
          BaseOptions(baseUrl: baseUrl)
        ).request(
          originalRequest.path,
          options: Options(
            method: originalRequest.method,
            headers: originalRequest.headers
          ),
          data: originalRequest.data,
          queryParameters: originalRequest.queryParameters
        );

        return handler.resolve(retryResponse);
      } on DioException catch (e) {
        if (e.response?.statusCode == HttpStatusCode.unauthorized.code) {
          logger.w('🔓 RefreshToken 만료, 로그아웃 처리');
          _ref.read(userSessionProvider.notifier).state = null;
          _ref.read(myPageViewModelProvider.notifier).reset();

          await _secureStorageService.delete();
          await _preferencesService.clearUser();
        }
        return handler.reject(e);
      }
    } else {
      super.onError(err, handler);
    }
  }
}