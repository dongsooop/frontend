import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/core/network/app_check_interceptor.dart';
import 'package:dongsoop/core/network/user_agent.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/providers/session_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/providers/auth_providers.dart';

typedef AuthDioFactory = Dio Function(BaseOptions? options);

class AuthInterceptor extends Interceptor {
  static const _baseUrl = 'https://dongsoop.site';
  static const _reissueEndpoint = '/token/reissue';

  final SecureStorageService _secureStorageService;
  final PreferencesService _preferencesService;
  final Ref _ref;
  final AppCheckTokenProvider _appCheckTokenProvider;
  final AuthDioFactory _dioFactory;
  final Future<void> Function()? _onSessionExpired;

  Future<_IssuedTokens>? _refreshInFlight;
  Future<void>? _sessionExpirationInFlight;

  AuthInterceptor(
    this._secureStorageService,
    this._preferencesService,
    this._ref,
    this._appCheckTokenProvider, {
    AuthDioFactory? dioFactory,
    Future<void> Function()? onSessionExpired,
  })  : _dioFactory = dioFactory ?? ((options) => Dio(options)),
        _onSessionExpired = onSessionExpired;

  Future<void> _attachAppCheckHeader(Map<String, dynamic> headers) async {
    try {
      final token = await _appCheckTokenProvider.getToken();
      if (token != null && token.isNotEmpty) {
        headers['X-Firebase-AppCheck'] = token;
      }
    } catch (_) {}
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final accessToken = await _secureStorageService.read('accessToken');
      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    } catch (_) {}

    await _attachAppCheckHeader(options.headers);

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != HttpStatusCode.unauthorized.code) {
      return super.onError(err, handler);
    }

    try {
      final tokens = await _refreshTokens();
      final retryResponse =
          await _retry(err.requestOptions, tokens.accessToken);
      return handler.resolve(retryResponse);
    } on _TerminalRefreshException {
      return handler.reject(_sessionExpiredError(err.requestOptions));
    } on DioException catch (refreshError) {
      if (refreshError.response?.statusCode ==
          HttpStatusCode.unauthorized.code) {
        _log('retried request rejected; expiring session');
        await _expireSession();
        return handler.reject(_sessionExpiredError(err.requestOptions));
      }

      _log(
        'reissue failed status=${refreshError.response?.statusCode} '
        'type=${refreshError.type.name}',
      );
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          type: refreshError.type,
          error: refreshError,
          message: '토큰 재발급에 실패했습니다.',
        ),
      );
    } catch (error, stackTrace) {
      _log('reissue failed error=$error\n$stackTrace');
      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          type: DioExceptionType.unknown,
          error: error,
          message: '토큰 재발급 응답을 처리하지 못했습니다.',
        ),
      );
    }
  }

  Future<_IssuedTokens> _refreshTokens() {
    final inFlight = _refreshInFlight;
    if (inFlight != null) {
      _log('joining in-flight reissue');
      return inFlight;
    }

    late final Future<_IssuedTokens> operation;
    operation = _performTokenRefresh().whenComplete(() {
      if (identical(_refreshInFlight, operation)) {
        _refreshInFlight = null;
      }
    });
    _refreshInFlight = operation;
    return operation;
  }

  Future<_IssuedTokens> _performTokenRefresh() async {
    final refreshToken = await _secureStorageService.read('refreshToken');
    if (refreshToken == null || refreshToken.trim().isEmpty) {
      _log('reissue skipped: refresh token missing');
      await _expireSession();
      throw const _TerminalRefreshException();
    }

    _log('reissue start tokenPresent=true length=${refreshToken.length}');

    try {
      final refreshDio = _dioFactory(
        BaseOptions(
          baseUrl: _baseUrl,
          headers: {
            'User-Agent': getUserAgent(),
            Headers.contentTypeHeader: Headers.textPlainContentType,
            Headers.acceptHeader: Headers.jsonContentType,
          },
        ),
      );
      await _attachAppCheckHeader(refreshDio.options.headers);

      final response = await refreshDio.post<dynamic>(
        _reissueEndpoint,
        data: refreshToken,
      );
      final data = response.data;
      if (data is! Map) {
        throw const FormatException(
            'Token reissue response must be an object.');
      }

      final accessToken = data['accessToken'];
      final newRefreshToken = data['refreshToken'];
      if (accessToken is! String ||
          accessToken.isEmpty ||
          newRefreshToken is! String ||
          newRefreshToken.isEmpty) {
        throw const FormatException('Token reissue response is incomplete.');
      }

      await _secureStorageService.write('accessToken', accessToken);
      await _secureStorageService.write('refreshToken', newRefreshToken);
      _log('reissue success status=${response.statusCode}');

      return _IssuedTokens(accessToken);
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode == HttpStatusCode.badRequest.code ||
          statusCode == HttpStatusCode.unauthorized.code) {
        _log('reissue rejected status=$statusCode; expiring session');
        await _expireSession();
        throw const _TerminalRefreshException();
      }
      rethrow;
    }
  }

  Future<Response<dynamic>> _retry(
    RequestOptions originalRequest,
    String accessToken,
  ) async {
    final headers = Map<String, dynamic>.from(originalRequest.headers)
      ..['Authorization'] = 'Bearer $accessToken';
    await _attachAppCheckHeader(headers);

    final retryDio = _dioFactory(
      BaseOptions(baseUrl: originalRequest.baseUrl),
    );
    return retryDio.request<dynamic>(
      originalRequest.path,
      data: originalRequest.data,
      queryParameters: originalRequest.queryParameters,
      cancelToken: originalRequest.cancelToken,
      onSendProgress: originalRequest.onSendProgress,
      onReceiveProgress: originalRequest.onReceiveProgress,
      options: Options(
        method: originalRequest.method,
        headers: headers,
        responseType: originalRequest.responseType,
        contentType: originalRequest.contentType,
        validateStatus: originalRequest.validateStatus,
        receiveDataWhenStatusError: originalRequest.receiveDataWhenStatusError,
        followRedirects: originalRequest.followRedirects,
        maxRedirects: originalRequest.maxRedirects,
        sendTimeout: originalRequest.sendTimeout,
        receiveTimeout: originalRequest.receiveTimeout,
        extra: originalRequest.extra,
      ),
    );
  }

  Future<void> _expireSession() {
    final inFlight = _sessionExpirationInFlight;
    if (inFlight != null) return inFlight;

    late final Future<void> operation;
    operation = _clearSession().whenComplete(() {
      if (identical(_sessionExpirationInFlight, operation)) {
        _sessionExpirationInFlight = null;
      }
    });
    _sessionExpirationInFlight = operation;
    return operation;
  }

  Future<void> _clearSession() async {
    await _secureStorageService.delete();
    await _preferencesService.clearUser();

    final onSessionExpired = _onSessionExpired;
    if (onSessionExpired != null) {
      await onSessionExpired();
      return;
    }

    await Future<void>.microtask(() {
      _ref.read(userSessionProvider.notifier).state = null;
      _ref.read(myPageViewModelProvider.notifier).reset();
      _ref.read(sessionExpiredProvider.notifier).state = true;
    });
  }

  DioException _sessionExpiredError(RequestOptions originalRequest) {
    return DioException(
      requestOptions: originalRequest,
      type: DioExceptionType.unknown,
      error: const SessionExpiredException(),
      message: '세션이 만료되었습니다.',
    );
  }

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[AuthRefresh] $message');
    }
  }
}

class _IssuedTokens {
  final String accessToken;

  const _IssuedTokens(this.accessToken);
}

class _TerminalRefreshException implements Exception {
  const _TerminalRefreshException();
}
