import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/data/auth/data_source/auth_data_source_impl.dart';
import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('로그인 제재 응답', () {
    test('일반 로그인 403의 서버 detail을 보존한다', () {
      final dataSource = _dataSource(
        _errorDio(
          statusCode: 403,
          data: const {
            'detail': '회원님은 2026년 10월 19일까지 이용이 제한됩니다.',
          },
        ),
      );

      expect(
        dataSource.signIn('user@dongyang.ac.kr', 'password', 'fcm-token'),
        throwsA(
          isA<UserSanctionedException>().having(
            (error) => error.message,
            'message',
            '회원님은 2026년 10월 19일까지 이용이 제한됩니다.',
          ),
        ),
      );
    });

    test('소셜 로그인 403도 서버 detail을 동일하게 보존한다', () {
      final dataSource = _dataSource(
        _errorDio(
          statusCode: 403,
          data: const {'detail': '현재 영구 이용 제한 상태입니다.'},
        ),
      );

      expect(
        dataSource.socialLogin(
          LoginPlatform.google,
          'social-token',
          'fcm-token',
        ),
        throwsA(
          isA<UserSanctionedException>().having(
            (error) => error.message,
            'message',
            '현재 영구 이용 제한 상태입니다.',
          ),
        ),
      );
    });

    test('403 detail이 비어 있으면 안전한 기본 문구를 사용한다', () {
      final dataSource = _dataSource(
        _errorDio(statusCode: 403, data: const {'detail': '  '}),
      );

      expect(
        dataSource.signIn('user@dongyang.ac.kr', 'password', 'fcm-token'),
        throwsA(
          isA<UserSanctionedException>().having(
            (error) => error.message,
            'message',
            const UserSanctionedException().message,
          ),
        ),
      );
    });
  });
}

AuthDataSourceImpl _dataSource(Dio plainDio) {
  return AuthDataSourceImpl(
    plainDio,
    Dio(BaseOptions(baseUrl: 'https://dongsoop.test')),
    _SecureStorageStub(),
    _PreferencesStub(),
  );
}

Dio _errorDio({
  required int statusCode,
  Object? data,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://dongsoop.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.reject(
          DioException(
            requestOptions: options,
            response: Response<Object?>(
              requestOptions: options,
              statusCode: statusCode,
              data: data,
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      },
    ),
  );
  return dio;
}

class _SecureStorageStub extends SecureStorageService {}

class _PreferencesStub extends PreferencesService {}
