import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:dongsoop/data/auth/data_source/auth_data_source_impl.dart';
import 'package:dongsoop/domain/auth/enum/login_platform.dart';
import 'package:dongsoop/domain/report/enum/sanction_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('로그인 제재 응답', () {
    test('일반 로그인 403의 제재 정보를 안내 모델로 변환한다', () {
      final dataSource = _dataSource(
        _errorDio(
          statusCode: 403,
          data: const {
            'detail': '회원님은 2026년 10월 19일까지 이용이 제한됩니다.',
            'sanction': {
              'isSanctioned': true,
              'sanctionType': 'TEMPORARY_BAN',
              'reason': '반복 욕설',
              'startDate': '2026-10-16T21:20:00',
              'endDate': '2026-10-19T21:20:00',
              'description': '경고 3회 누적으로 인한 자동 3일 정지',
            },
          },
        ),
      );

      expect(
        dataSource.signIn('user@dongyang.ac.kr', 'password', 'fcm-token'),
        throwsA(
          isA<UserSanctionedException>()
              .having(
                (error) => error.message,
                'message',
                '회원님은 2026년 10월 19일까지 이용이 제한됩니다.',
              )
              .having(
                (error) => error.sanction?.sanctionType,
                'sanction type',
                SanctionType.TEMPORARY_BAN,
              )
              .having(
                (error) => error.sanction?.reason,
                'reason',
                '반복 욕설',
              )
              .having(
                (error) => error.sanction?.periodLabel,
                'period',
                '2026. 10. 16 21:20 ~ 2026. 10. 19 21:20',
              ),
        ),
      );
    });

    test('소셜 로그인의 영구정지 정보도 동일하게 전달한다', () {
      final dataSource = _dataSource(
        _errorDio(
          statusCode: 403,
          data: const {
            'detail': '현재 영구 이용 제한 상태입니다.',
            'sanction': {
              'isSanctioned': true,
              'sanctionType': 'PERMANENT_BAN',
              'reason': '반복 신고',
              'startDate': '2026-10-16T21:20:00',
              'endDate': null,
              'description': '영구 이용 제한',
            },
          },
        ),
      );

      expect(
        dataSource.socialLogin(
          LoginPlatform.google,
          'social-token',
          'fcm-token',
        ),
        throwsA(
          isA<UserSanctionedException>()
              .having(
                (error) => error.message,
                'message',
                '현재 영구 이용 제한 상태입니다.',
              )
              .having(
                (error) => error.sanction?.sanctionType,
                'sanction type',
                SanctionType.PERMANENT_BAN,
              )
              .having(
                (error) => error.sanction?.endDateLabel,
                'end date',
                '영구',
              ),
        ),
      );
    });

    test('sanction 속성이 없는 403은 제재로 오인하지 않는다', () async {
      final dataSource = _dataSource(
        _errorDio(
          statusCode: 403,
          data: const {'detail': '로그인 권한이 없습니다.'},
        ),
      );

      try {
        await dataSource.signIn(
          'user@dongyang.ac.kr',
          'password',
          'fcm-token',
        );
        fail('예외가 발생해야 합니다.');
      } catch (error) {
        expect(error.runtimeType, LoginException);
        expect((error as LoginException).message, '로그인 권한이 없습니다.');
      }
    });

    test('sanction 속성은 있지만 형식이 잘못되면 기본 제재 안내를 사용한다', () {
      final dataSource = _dataSource(
        _errorDio(
          statusCode: 403,
          data: const {'detail': '  ', 'sanction': []},
        ),
      );

      expect(
        dataSource.signIn('user@dongyang.ac.kr', 'password', 'fcm-token'),
        throwsA(
          isA<UserSanctionedException>()
              .having(
                (error) => error.message,
                'message',
                const UserSanctionedException().message,
              )
              .having(
                (error) => error.sanction,
                'sanction',
                isNull,
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
