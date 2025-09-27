import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorageService;
  final PreferencesService _preferencesService;
  final Ref _ref;

  AuthInterceptor(
      this._secureStorageService,
      this._preferencesService,
      this._ref,
      );

  Future<String?> _appCheckToken() async {
    try {
      return await FirebaseAppCheck.instance.getToken();
    } catch (_) {
      return null;
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final accessToken = await _secureStorageService.read('accessToken');
      options.headers['Authorization'] = 'Bearer $accessToken';
    } catch (e) {
    }
    try {
      final baseUrl = dotenv.maybeGet('BASE_URL');
      if (baseUrl != null && baseUrl.isNotEmpty) {
        final baseHost = Uri.parse(baseUrl).host;
        if (options.uri.host == baseHost) {
          final t = await _appCheckToken();
          if (t != null) {
            options.headers['X-Firebase-AppCheck'] = t;
            debugPrint('[AuthInterceptor][AppCheck] attached to ${options.uri}');
          }
        }
      }
    } catch (_) {}

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == HttpStatusCode.unauthorized.code) {
      try {
        final refreshToken = await _secureStorageService.read('refreshToken');
        final refreshDio = Dio();
        final baseUrl = dotenv.get('BASE_URL');
        final endpoint = dotenv.get('REISSUE_ENDPOINT');
        final url = '$baseUrl$endpoint';

        try {
          final t = await _appCheckToken();
          if (t != null) {
            refreshDio.options.headers['X-Firebase-AppCheck'] = t;
          }
        } catch (_) {}

        final refreshResponse = await refreshDio.post(url, data: refreshToken);
        final newAccessToken = refreshResponse.data['accessToken'].toString();
        final newRefreshToken = refreshResponse.data['refreshToken'].toString();
        await _secureStorageService.write('accessToken', newAccessToken);
        await _secureStorageService.write('refreshToken', newRefreshToken);
        final originalRequest = err.requestOptions;
        originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';

        final retryDio = Dio(BaseOptions(baseUrl: baseUrl));
        try {
          final t = await _appCheckToken();
          if (t != null) {
            originalRequest.headers['X-Firebase-AppCheck'] = t;
          }
        } catch (_) {}

        final retryResponse = await retryDio.request(
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