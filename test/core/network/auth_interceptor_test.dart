import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/network/app_check_interceptor.dart';
import 'package:dongsoop/core/network/auth_interceptor.dart';
import 'package:dongsoop/core/network/blind_date_stomp_service.dart';
import 'package:dongsoop/core/network/session_end_reason_parser.dart';
import 'package:dongsoop/core/network/stomp_service.dart';
import 'package:dongsoop/core/session/session_manager.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/domain/auth/enum/session_end_reason.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthInterceptor 401 재발급', () {
    test('refresh token이 없으면 재발급 요청 없이 세션을 만료시킨다', () async {
      final storage = _SecureStorageStub(accessToken: 'expired-access');
      final preferences = _PreferencesStub();
      var factoryCallCount = 0;
      var expirationCount = 0;
      final reasons = <SessionEndReason>[];
      final interceptor = AuthInterceptor(
        storage,
        preferences,
        _RefStub(),
        const _AppCheckStub(),
        dioFactory: (_) {
          factoryCallCount += 1;
          return Dio();
        },
        onSessionEnded: (reason) async {
          await storage.delete();
          await preferences.clearUser();
          expirationCount += 1;
          reasons.add(reason);
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
      expect(reasons, [SessionEndReason.expired]);
    });

    test('재발급 400을 제재 API 오류가 아닌 세션 만료로 변환한다', () async {
      final storage = _SecureStorageStub(
        accessToken: 'expired-access',
        refreshToken: 'saved-refresh-token',
      );
      final preferences = _PreferencesStub();
      RequestOptions? reissueRequest;
      var expirationCount = 0;
      final reasons = <SessionEndReason>[];
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
        onSessionEnded: (reason) async {
          await storage.delete();
          await preferences.clearUser();
          expirationCount += 1;
          reasons.add(reason);
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
      expect(reasons, [SessionEndReason.expired]);
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

    test('고정 제재 코드가 포함된 401은 재발급 없이 제재 종료로 전달한다', () async {
      final storage = _SecureStorageStub(
        accessToken: 'blocked-access',
        refreshToken: 'saved-refresh-token',
      );
      final preferences = _PreferencesStub();
      var factoryCallCount = 0;
      final reasons = <SessionEndReason>[];
      final interceptor = AuthInterceptor(
        storage,
        preferences,
        _RefStub(),
        const _AppCheckStub(),
        dioFactory: (_) {
          factoryCallCount += 1;
          return Dio();
        },
        onSessionEnded: (reason) async {
          await storage.delete();
          await preferences.clearUser();
          reasons.add(reason);
        },
      );

      final dio = _unauthorizedDio(
        interceptor,
        data: const {
          'code': sanctionedMemberErrorCode,
          'detail': '현재 제재 중인 계정입니다.',
        },
      );

      await expectLater(
        dio.get('/reports'),
        throwsA(
          isA<DioException>().having(
            (error) => error.error,
            'error',
            isA<SessionExpiredException>(),
          ),
        ),
      );
      expect(factoryCallCount, 0);
      expect(reasons, [SessionEndReason.sanctioned]);
      expect(storage.deleted, isTrue);
      expect(preferences.cleared, isTrue);
    });

    test('동시 재발급 거절은 세션 종료 콜백을 한 번만 실행한다', () async {
      final storage = _SecureStorageStub(
        accessToken: 'expired-access',
        refreshToken: 'saved-refresh-token',
      );
      final preferences = _PreferencesStub();
      var reissueCount = 0;
      var expirationCount = 0;
      final reasons = <SessionEndReason>[];
      final interceptor = AuthInterceptor(
        storage,
        preferences,
        _RefStub(),
        const _AppCheckStub(),
        dioFactory: (options) => _handledDio(
          options,
          (_) async {
            reissueCount += 1;
            await Future<void>.delayed(const Duration(milliseconds: 10));
            return _jsonResponse(
              401,
              const {'code': sanctionedMemberErrorCode},
            );
          },
        ),
        onSessionEnded: (reason) async {
          expirationCount += 1;
          reasons.add(reason);
          await Future<void>.delayed(const Duration(milliseconds: 20));
          await storage.delete();
          await preferences.clearUser();
        },
      );
      final dio = _unauthorizedDio(interceptor);

      final results = await Future.wait([
        dio.get('/reports').then<Object>((value) => value).catchError(
              (Object error) => error,
            ),
        dio.get('/reports/admin').then<Object>((value) => value).catchError(
              (Object error) => error,
            ),
      ]);

      expect(results, everyElement(isA<DioException>()));
      expect(reissueCount, 1);
      expect(expirationCount, 1);
      expect(reasons, [SessionEndReason.sanctioned]);
    });
  });

  group('SessionManager', () {
    test('동시 종료 요청을 한 번 정리하고 제재 사유를 우선한다', () async {
      final operations = <String>[];
      final reasons = <SessionEndReason>[];
      final disconnectGate = Completer<void>();
      final manager = SessionManager(
        disconnectChatSockets: () async {
          operations.add('chat');
          await disconnectGate.future;
        },
        disconnectBlindDateSocket: () => operations.add('blind-date'),
        clearSecureStorage: () => operations.add('secure-storage'),
        clearPreferences: () => operations.add('preferences'),
        onSessionEnded: reasons.add,
        onSessionActivated: () => operations.add('activated'),
      );

      final expired = manager.end(SessionEndReason.expired);
      await Future<void>.delayed(Duration.zero);
      final sanctioned = manager.end(SessionEndReason.sanctioned);
      disconnectGate.complete();
      await Future.wait([expired, sanctioned]);

      expect(operations, [
        'chat',
        'blind-date',
        'secure-storage',
        'preferences',
      ]);
      expect(reasons, [SessionEndReason.sanctioned]);

      await manager.end(SessionEndReason.expired);
      expect(reasons, hasLength(1));
    });

    test('새 로그인 활성화 후에는 다음 세션 종료를 다시 처리한다', () async {
      var cleanupCount = 0;
      final reasons = <SessionEndReason>[];
      final manager = SessionManager(
        disconnectChatSockets: () => cleanupCount += 1,
        disconnectBlindDateSocket: () {},
        clearSecureStorage: () {},
        clearPreferences: () {},
        onSessionEnded: reasons.add,
        onSessionActivated: () {},
      );

      await manager.end(SessionEndReason.expired);
      manager.activateSession();
      await manager.end(SessionEndReason.sanctioned);

      expect(cleanupCount, 2);
      expect(
        reasons,
        [SessionEndReason.expired, SessionEndReason.sanctioned],
      );
    });
  });

  group('세션 종료 원인 파싱', () {
    test('한국어 detail은 추측하지 않고 고정 코드만 제재로 판별한다', () {
      expect(
        sessionEndReasonFromResponseData(
          const {'detail': '현재 제재 중인 계정입니다.'},
        ),
        isNull,
      );
      expect(
        sessionEndReasonFromResponseData(
          const {'code': sanctionedMemberErrorCode},
        ),
        SessionEndReason.sanctioned,
      );
    });

    test('STOMP 401과 403을 세션 종료 원인으로 변환한다', () {
      expect(
        sessionEndReasonFromRealtimeError('WebSocket error: 401'),
        SessionEndReason.expired,
      );
      expect(
        sessionEndReasonFromRealtimeError('STOMP ERROR 403'),
        SessionEndReason.sanctioned,
      );
      expect(sessionEndReasonFromRealtimeError('connection closed'), isNull);
    });

    test('이미 연결된 STOMP의 403은 전역 세션 종료로 번역하지 않는다', () {
      expect(
        sessionEndReasonFromRealtimeConnectError(
          'STOMP ERROR 403',
          hasConnected: true,
        ),
        isNull,
      );
      expect(
        sessionEndReasonFromRealtimeConnectError(
          'STOMP ERROR 403',
          hasConnected: false,
        ),
        SessionEndReason.sanctioned,
      );
    });

    test('연결 전에도 모든 실시간 연결 종료를 안전하게 호출할 수 있다', () async {
      final storage = _SecureStorageStub();
      final stompService = StompService(storage);
      final blindDateStompService = BlindDateStompService(storage);

      expect(stompService.disconnectAll, returnsNormally);
      await expectLater(blindDateStompService.disconnect(), completes);
    });
  });
}

Dio _unauthorizedDio(
  AuthInterceptor interceptor, {
  Object data = const {'detail': '토큰이 만료되었습니다.'},
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://dongsoop.site'));
  dio.httpClientAdapter = _CallbackAdapter(
    (_) async => _jsonResponse(
      401,
      data,
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
