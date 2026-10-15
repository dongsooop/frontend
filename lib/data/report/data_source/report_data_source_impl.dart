import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/report/data_source/report_data_source.dart';
import 'package:dongsoop/domain/report/exception/message_report_exception.dart';
import 'package:dongsoop/domain/report/model/blind_date_report_request.dart';
import 'package:dongsoop/domain/report/model/chat_report_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_response.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';

class ReportDataSourceImpl implements ReportDataSource {
  final Dio _authDio;

  ReportDataSourceImpl(
    this._authDio,
  );

  @override
  Future<void> reportChatMessage(ChatReportRequest request) async {
    await _submitMessageReport(
      endpoint: '/reports/chat',
      data: request.toJson(),
      supportsExpiredSession: false,
    );
  }

  @override
  Future<void> reportBlindDateMessage(
    BlindDateReportRequest request,
  ) async {
    await _submitMessageReport(
      endpoint: '/reports/blinddate',
      data: request.toJson(),
      supportsExpiredSession: true,
    );
  }

  @override
  Future<ReportSanctionResponse> getSanctionStatus() async {
    final endpoint = '/reports/sanction-status';

    try {
      final response = await _authDio.get(endpoint);

      if (response.statusCode == HttpStatusCode.ok.code) {
        final data = response.data;

        return ReportSanctionResponse.fromJson(data);
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sanctionWriteReport(ReportAdminSanctionRequest request) async {
    const endpoint = '/reports/sanctions';

    try {
      final response = await _authDio.post(endpoint, data: request.toJson());
      if (response.statusCode != HttpStatusCode.created.code) {
        throw const SanctionException('제재 처리 중 예상하지 못한 응답을 받았습니다.');
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final detail = e.response?.data;
      if (statusCode == HttpStatusCode.badRequest.code) {
        throw SanctionRequestValidationException(
          _problemDetail(detail, fallback: '제재 정보를 다시 확인해 주세요.'),
        );
      } else if (statusCode == HttpStatusCode.forbidden.code) {
        throw NoAdminAuthorityException(
          _problemDetail(detail, fallback: '관리자 권한이 없습니다.'),
        );
      } else if (statusCode == HttpStatusCode.notFound.code) {
        throw NotFoundSanctionException(
          _problemDetail(detail, fallback: '신고 또는 회원을 찾을 수 없습니다.'),
        );
      } else if (statusCode == HttpStatusCode.conflict.code) {
        throw AlreadyProcessedException(
          _problemDetail(detail, fallback: '이미 처리된 신고입니다.'),
        );
      }
      rethrow;
    }
  }

  @override
  Future<List<ReportAdminSanctionResponse>?> getReports(
    String type,
    String sort, {
    int page = 0,
    int size = 10,
  }) async {
    const endpoint = '/reports/admin';

    try {
      final response = await _authDio.get(
        endpoint,
        queryParameters: {
          'filter': type,
          'sort': sort,
          'page': page,
          'size': size,
        },
      );
      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data;

        final List<ReportAdminSanctionResponse> reports = data
            .map((e) =>
                ReportAdminSanctionResponse.fromJson(e as Map<String, dynamic>))
            .toList();

        return reports;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.badRequest.code) {
        throw BadRequestParameterException();
      } else if (e.response?.statusCode == HttpStatusCode.forbidden.code) {
        throw NoAdminAuthorityException();
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _submitMessageReport({
    required String endpoint,
    required Map<String, dynamic> data,
    required bool supportsExpiredSession,
  }) async {
    try {
      final response = await _authDio.post(endpoint, data: data);

      if (response.statusCode != HttpStatusCode.created.code) {
        throw MessageReportException(
          failure: MessageReportFailure.unknown,
          message: _fallbackMessage(MessageReportFailure.unknown),
          statusCode: response.statusCode,
        );
      }
    } on MessageReportException {
      rethrow;
    } on DioException catch (error) {
      if (error.error is SessionExpiredException) {
        throw error.error!;
      }

      final statusCode = error.response?.statusCode;
      final failure = _failureFor(
        statusCode,
        supportsExpiredSession: supportsExpiredSession,
      );
      throw MessageReportException(
        failure: failure,
        message: _problemDetail(
          error.response?.data,
          fallback: _fallbackMessage(failure),
        ),
        statusCode: statusCode,
      );
    } catch (_) {
      throw MessageReportException(
        failure: MessageReportFailure.unknown,
        message: _fallbackMessage(MessageReportFailure.unknown),
      );
    }
  }

  MessageReportFailure _failureFor(
    int? statusCode, {
    required bool supportsExpiredSession,
  }) {
    if (statusCode == HttpStatusCode.badRequest.code) {
      return MessageReportFailure.invalidRequest;
    }
    if (statusCode == HttpStatusCode.forbidden.code) {
      return MessageReportFailure.forbidden;
    }
    if (statusCode == HttpStatusCode.notFound.code) {
      return MessageReportFailure.notFound;
    }
    if (statusCode == HttpStatusCode.conflict.code) {
      return MessageReportFailure.duplicate;
    }
    if (supportsExpiredSession && statusCode == HttpStatusCode.gone.code) {
      return MessageReportFailure.expired;
    }
    return MessageReportFailure.unknown;
  }

  String _problemDetail(Object? data, {required String fallback}) {
    if (data is Map) {
      final detail = data['detail']?.toString().trim();
      if (detail != null && detail.isNotEmpty) return detail;
    }
    return fallback;
  }

  String _fallbackMessage(MessageReportFailure failure) {
    switch (failure) {
      case MessageReportFailure.invalidRequest:
        return '요청 데이터의 형식이 올바르지 않습니다.';
      case MessageReportFailure.forbidden:
        return '신고할 권한이 없습니다.';
      case MessageReportFailure.notFound:
        return '신고 대상을 찾을 수 없습니다.';
      case MessageReportFailure.duplicate:
        return '이미 신고한 대상입니다.';
      case MessageReportFailure.expired:
        return '종료된 과팅의 메시지는 신고할 수 없습니다.';
      case MessageReportFailure.unknown:
        return '신고 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.';
    }
  }
}
