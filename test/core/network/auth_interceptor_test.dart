import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/network/app_check_interceptor.dart';
import 'package:dongsoop/core/network/auth_interceptor.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthInterceptor 401 재발급', () {
    test('refresh token이 없으면 재발급 요청 없이 세션을 만료시킨다', () async {
      final storage = _SecureStorageStub(accessToken: 'expired-access');
      final preferences = _PreferencesStub();
      var factoryCallCount = 0;
      var expirationCount = 0;
      final interceptor = AuthInterceptor(
        storage,
        preferences,
        _RefStub(),
        const _AppCheckStub(),
        dioFactory: (_) {
          factoryCallCount += 1;
          return Dio();
        },
        onSessionExpired: () async {
          expirationCount += 1;
        },
      );

      final dio = _unauthorizedDio(interceptor);

      await expectLater(
        dio.get('/reports/sanction-status'),
        throwsA(
          isA<DioException>().having(
            (error) => error.error,
            'error',
            isA<SessionExpiredException>(),
          ),
        ),
      );
      expect(factoryCallCount, 0);
      expect(storage.deleted, isTrue);
      expect(preferences.cleared, isTrue);
      expect(expirationCount, 1);
    });

    test('재발급 400을 제재 API 오류가 아닌 세션 만료로 변환한다', () async {
      final storage = _SecureStorageStub(
        accessToken: 'expired-access',
        refreshToken: 'saved-refresh-token',
      );
      final preferences = _PreferencesStub();
      RequestOptions? reissueRequest;
      var expirationCount = 0;
      final interceptor = AuthInterceptor(
        storage,
        preferences,
        _RefStub(),
        const _AppCheckStub(),
        dioFactory: (options) => _handledDio(
          options,
          (request) async {
            reissueRequest = request;
            return _jsonResponse(
              400,
              const {'detail': '요청 데이터의 포맷이 올바르지 않습니다.'},
            );
          },
        ),
        onSessionExpired: () async {
          expirationCount += 1;
        },
      );

      final dio = _unauthorizedDio(interceptor);

      await expectLater(
        dio.get('/reports/sanction-status'),
        throwsA(
          isA<DioException>()
              .having(
                (error) => error.requestOptions.path,
                'original path',
                '/reports/sanction-status',
              )
              .having(
                (error) => error.error,
                'error',
                isA<SessionExpiredException>(),
              ),
        ),
      );
      expect(reissueRequest?.path, '/token/reissue');
      expect(reissueRequest?.data, 'saved-refresh-token');
      expect(reissueRequest?.contentType, Headers.textPlainContentType);
      expect(storage.deleted, isTrue);
      expect(preferences.cleared, isTrue);
      expect(expirationCount, 1);
    });

    test('동시에 발생한 401은 한 번만 재발급하고 각각 원 요청을 재시도한다', () async {
      final storage = _SecureStorageStub(
        accessToken: 'expired-access',
        refreshToken: 'saved-refresh-token',
      );
      final preferences = _PreferencesStub();
      var reissueCount = 0;
      var retryCount = 0;
      final retryAuthorizations = <Object?>[];
      final interceptor = AuthInterceptor(
        storage,
        preferences,
        _RefStub(),
        const _AppCheckStub(),
        dioFactory: (options) => _handledDio(
          options,
          (request) async {
            if (request.path == '/token/reissue') {
              reissueCount += 1;
              await Future<void>.delayed(const Duration(milliseconds: 20));
              return _jsonResponse(
                200,
                const {
                  'accessToken': 'new-access-token',
                  'refreshToken': 'new-refresh-token',
                },
              );
            }

            retryCount += 1;
            retryAuthorizations.add(request.headers['Authorization']);
            return _jsonResponse(200, const {'isSanctioned': false});
          },
        ),
      );
      final dio = _unauthorizedDio(interceptor);

      final responses = await Future.wait([
        dio.get('/reports/sanction-status'),
        dio.get('/reports/admin'),
      ]);

      expect(reissueCount, 1);
      expect(retryCount, 2);
      expect(
        retryAuthorizations,
        everyElement('Bearer new-access-token'),
      );
      expect(
          responses.map((response) => response.statusCode), everyElement(200));
      expect(storage.values['accessToken'], 'new-access-token');
      expect(storage.values['refreshToken'], 'new-refresh-token');
      expect(storage.deleted, isFalse);
      expect(preferences.cleared, isFalse);
    });
  });
}

Dio _unauthorizedDio(AuthInterceptor interceptor) {
  final dio = Dio(BaseOptions(baseUrl: 'https://dongsoop.site'));
  dio.httpClientAdapter = _CallbackAdapter(
    (_) async => _jsonResponse(
      401,
      const {'detail': '토큰이 만료되었습니다.'},
    ),
  );
  dio.interceptors.add(interceptor);
  return dio;
}

Dio _handledDio(
  BaseOptions? options,
  Future<ResponseBody> Function(RequestOptions request) onRequest,
) {
  final dio = Dio(options);
  dio.httpClientAdapter = _CallbackAdapter(onRequest);
  return dio;
}

ResponseBody _jsonResponse(int statusCode, Object? data) {
  return ResponseBody.fromString(
    jsonEncode(data),
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

class _CallbackAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions request) callback;

  _CallbackAdapter(this.callback);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return callback(options);
  }

  @override
  void close({bool force = false}) {}
}

class _SecureStorageStub extends SecureStorageService {
  final Map<String, String> values;
  bool deleted = false;

  _SecureStorageStub({String? accessToken, String? refreshToken})
      : values = {
          if (accessToken != null) 'accessToken': accessToken,
          if (refreshToken != null) 'refreshToken': refreshToken,
        };

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<void> delete() async {
    deleted = true;
    values.remove('accessToken');
    values.remove('refreshToken');
  }
}

class _PreferencesStub extends PreferencesService {
  bool cleared = false;

  @override
  Future<void> clearUser() async {
    cleared = true;
  }
}

class _AppCheckStub implements AppCheckTokenProvider {
  const _AppCheckStub();

  @override
  Future<String?> getToken() async => 'app-check-token';
}

class _RefStub implements Ref {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
