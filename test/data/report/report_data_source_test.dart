import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/data/report/data_source/report_data_source_impl.dart';
import 'package:dongsoop/domain/report/enum/report_reason.dart';
import 'package:dongsoop/domain/report/exception/message_report_exception.dart';
import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('메시지 신고 제출', () {
    test('채팅 신고를 올바른 경로와 본문으로 전송하고 201을 성공 처리한다', () async {
      final requests = <RequestOptions>[];
      final dataSource = ReportDataSourceImpl(_successDio(requests));
      final request = ChatReportRequest(
        roomId: 'room-1',
        messageId: 'message-1',
        reason: ReportReason.SPAM,
        description: '광고 도배',
      );

      await dataSource.reportChatMessage(request);

      expect(requests, hasLength(1));
      expect(requests.single.method, 'POST');
      expect(requests.single.path, '/reports/chat');
      expect(requests.single.data, {
        'roomId': 'room-1',
        'messageId': 'message-1',
        'reason': 'SPAM',
        'description': '광고 도배',
      });
    });

    test('과팅 신고를 올바른 경로와 본문으로 전송한다', () async {
      final requests = <RequestOptions>[];
      final dataSource = ReportDataSourceImpl(_successDio(requests));
      final request = BlindDateReportRequest(
        sessionId: 'session-1',
        messageId: 'message-2',
        reason: ReportReason.HATE_SPEECH,
      );

      await dataSource.reportBlindDateMessage(request);

      expect(requests, hasLength(1));
      expect(requests.single.method, 'POST');
      expect(requests.single.path, '/reports/blinddate');
      expect(requests.single.data, {
        'sessionId': 'session-1',
        'messageId': 'message-2',
        'reason': 'HATE_SPEECH',
      });
    });

    final commonFailures = <int, MessageReportFailure>{
      400: MessageReportFailure.invalidRequest,
      403: MessageReportFailure.forbidden,
      404: MessageReportFailure.notFound,
      409: MessageReportFailure.duplicate,
    };

    for (final entry in commonFailures.entries) {
      test('채팅 신고의 ${entry.key} 응답을 ${entry.value.name} 오류로 변환한다', () {
        final dataSource = ReportDataSourceImpl(
          _errorDio(statusCode: entry.key),
        );

        expect(
          dataSource.reportChatMessage(_chatRequest),
          throwsA(
            isA<MessageReportException>()
                .having((error) => error.failure, 'failure', entry.value)
                .having((error) => error.statusCode, 'statusCode', entry.key),
          ),
        );
      });

      test('과팅 신고의 ${entry.key} 응답을 ${entry.value.name} 오류로 변환한다', () {
        final dataSource = ReportDataSourceImpl(
          _errorDio(statusCode: entry.key),
        );

        expect(
          dataSource.reportBlindDateMessage(_blindDateRequest),
          throwsA(
            isA<MessageReportException>()
                .having((error) => error.failure, 'failure', entry.value)
                .having((error) => error.statusCode, 'statusCode', entry.key),
          ),
        );
      });
    }

    test('과팅 신고의 410 응답을 만료 오류로 변환한다', () {
      final dataSource = ReportDataSourceImpl(_errorDio(statusCode: 410));

      expect(
        dataSource.reportBlindDateMessage(_blindDateRequest),
        throwsA(
          isA<MessageReportException>()
              .having(
                (error) => error.failure,
                'failure',
                MessageReportFailure.expired,
              )
              .having(
                (error) => error.message,
                'message',
                '종료된 과팅의 메시지는 신고할 수 없습니다.',
              ),
        ),
      );
    });

    test('채팅 신고의 예상하지 않은 410 응답은 일반 오류로 변환한다', () {
      final dataSource = ReportDataSourceImpl(_errorDio(statusCode: 410));

      expect(
        dataSource.reportChatMessage(_chatRequest),
        throwsA(
          isA<MessageReportException>().having(
            (error) => error.failure,
            'failure',
            MessageReportFailure.unknown,
          ),
        ),
      );
    });

    test('서버 ProblemDetail의 detail을 오류 메시지로 보존한다', () {
      final dataSource = ReportDataSourceImpl(
        _errorDio(
          statusCode: 409,
          data: const {'detail': '이미 신고한 메시지입니다.'},
        ),
      );

      expect(
        dataSource.reportChatMessage(_chatRequest),
        throwsA(
          isA<MessageReportException>().having(
            (error) => error.message,
            'message',
            '이미 신고한 메시지입니다.',
          ),
        ),
      );
    });

    test('ProblemDetail이 없거나 비어 있으면 상태별 기본 메시지를 사용한다', () {
      final dataSource = ReportDataSourceImpl(
        _errorDio(statusCode: 404, data: const {'detail': '  '}),
      );

      expect(
        dataSource.reportChatMessage(_chatRequest),
        throwsA(
          isA<MessageReportException>().having(
            (error) => error.message,
            'message',
            '신고 대상을 찾을 수 없습니다.',
          ),
        ),
      );
    });

    test('서버 오류를 알 수 없는 신고 오류로 변환한다', () {
      final dataSource = ReportDataSourceImpl(_errorDio(statusCode: 500));

      expect(
        dataSource.reportChatMessage(_chatRequest),
        throwsA(
          isA<MessageReportException>().having(
            (error) => error.failure,
            'failure',
            MessageReportFailure.unknown,
          ),
        ),
      );
    });

    test('응답이 없는 네트워크 오류를 알 수 없는 신고 오류로 변환한다', () {
      final dataSource = ReportDataSourceImpl(_networkErrorDio());

      expect(
        dataSource.reportChatMessage(_chatRequest),
        throwsA(
          isA<MessageReportException>()
              .having(
                (error) => error.failure,
                'failure',
                MessageReportFailure.unknown,
              )
              .having((error) => error.statusCode, 'statusCode', isNull),
        ),
      );
    });

    test('세션 만료 예외는 신고 오류로 감싸지 않고 그대로 전달한다', () {
      final dataSource = ReportDataSourceImpl(_sessionExpiredDio());

      expect(
        dataSource.reportChatMessage(_chatRequest),
        throwsA(isA<SessionExpiredException>()),
      );
    });

    test('201이 아닌 성공 응답도 알 수 없는 신고 오류로 처리한다', () {
      final dataSource = ReportDataSourceImpl(
        _successDio(<RequestOptions>[], statusCode: 200),
      );

      expect(
        dataSource.reportChatMessage(_chatRequest),
        throwsA(
          isA<MessageReportException>()
              .having(
                (error) => error.failure,
                'failure',
                MessageReportFailure.unknown,
              )
              .having((error) => error.statusCode, 'statusCode', 200),
        ),
      );
    });
  });
}

final _chatRequest = ChatReportRequest(
  roomId: 'room-1',
  messageId: 'message-1',
  reason: ReportReason.OTHER,
);

final _blindDateRequest = BlindDateReportRequest(
  sessionId: 'session-1',
  messageId: 'message-1',
  reason: ReportReason.OTHER,
);

Dio _successDio(
  List<RequestOptions> requests, {
  int statusCode = 201,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://dongsoop.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        requests.add(options);
        handler.resolve(
          Response<void>(
            requestOptions: options,
            statusCode: statusCode,
          ),
        );
      },
    ),
  );
  return dio;
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

Dio _networkErrorDio() {
  final dio = Dio(BaseOptions(baseUrl: 'https://dongsoop.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
          ),
        );
      },
    ),
  );
  return dio;
}

Dio _sessionExpiredDio() {
  final dio = Dio(BaseOptions(baseUrl: 'https://dongsoop.test'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.reject(
          DioException(
            requestOptions: options,
            error: const SessionExpiredException(),
            type: DioExceptionType.unknown,
          ),
        );
      },
    ),
  );
  return dio;
}
