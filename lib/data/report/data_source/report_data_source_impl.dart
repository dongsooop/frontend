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
import 'package:flutter/foundation.dart';

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
    const endpoint = '/reports/sanction-status';

    try {
      _logSanctionStatus('request GET $endpoint');
      final response = await _authDio.get(endpoint);
      _logSanctionStatus(
        'response status=${response.statusCode} '
        'type=${response.data.runtimeType} body=${response.data}',
      );

      if (response.statusCode != HttpStatusCode.ok.code) {
        throw const SanctionStatusException();
      }

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const SanctionStatusException(
          '제재 상태 응답 형식이 올바르지 않습니다. 다시 시도해 주세요.',
        );
      }

      return ReportSanctionResponse.fromJson(data);
    } on SanctionStatusException {
      rethrow;
    } on DioException catch (error) {
      _logSanctionStatus(
        'dio-error status=${error.response?.statusCode} '
        'type=${error.type.name} body=${error.response?.data}',
      );
      if (error.error is SessionExpiredException) {
        throw error.error!;
      }

      throw SanctionStatusException(
        _problemDetail(
          error.response?.data,
          fallback: '제재 상태를 확인하지 못했습니다. 잠시 후 다시 시도해 주세요.',
        ),
      );
    } catch (error, stackTrace) {
      _logSanctionStatus(
        'parse-error error=$error\n$stackTrace',
      );
      throw const SanctionStatusException(
        '제재 상태 응답을 처리하지 못했습니다. 다시 시도해 주세요.',
      );
    }
  }

  @override
  Future<void> sanctionWriteReport(ReportAdminSanctionRequest request) async {
    const endpoint = '/reports/sanctions';

    try {
      _logAdminReport(
        'request POST $endpoint reportId=${request.reportId} '
        'targetMemberId=${request.targetMemberId} '
        'sanctionType=${request.sanctionType.name} '
        'hasReason=${request.sanctionReason?.trim().isNotEmpty == true} '
        'hasEndAt=${request.sanctionEndAt != null}',
      );
      final response = await _authDio.post(endpoint, data: request.toJson());
      _logAdminReport('response POST $endpoint status=${response.statusCode}');
      if (response.statusCode != HttpStatusCode.created.code) {
        throw const SanctionException('제재 처리 중 예상하지 못한 응답을 받았습니다.');
      }
    } on DioException catch (e) {
      _logAdminReport(
        'dio-error POST $endpoint status=${e.response?.statusCode} '
        'type=${e.type.name} body=${e.response?.data}',
      );
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
  Future<void> dismissReport(int reportId) async {
    final endpoint = '/reports/$reportId/dismiss';

    try {
      _logAdminReport('request POST $endpoint reportId=$reportId');
      final response = await _authDio.post(endpoint);
      _logAdminReport('response POST $endpoint status=${response.statusCode}');
      if (response.statusCode != HttpStatusCode.noContent.code) {
        throw const SanctionException(
          '신고 처리 중 예상하지 못한 응답을 받았습니다.',
        );
      }
    } on DioException catch (e) {
      _logAdminReport(
        'dio-error POST $endpoint status=${e.response?.statusCode} '
        'type=${e.type.name} body=${e.response?.data}',
      );
      final statusCode = e.response?.statusCode;
      final detail = e.response?.data;
      if (statusCode == HttpStatusCode.forbidden.code) {
        throw NoAdminAuthorityException(
          _problemDetail(detail, fallback: '관리자 권한이 없습니다.'),
        );
      } else if (statusCode == HttpStatusCode.notFound.code) {
        throw NotFoundSanctionException(
          _problemDetail(detail, fallback: '신고를 찾을 수 없습니다.'),
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
      _logAdminReport(
        'request GET $endpoint filter=$type sort=$sort page=$page size=$size',
      );
      final response = await _authDio.get(
        endpoint,
        queryParameters: {
          'filter': type,
          'sort': sort,
          'page': page,
          'size': size,
        },
      );
      final itemCount =
          response.data is List ? (response.data as List).length : null;
      _logAdminReport(
        'response GET $endpoint status=${response.statusCode} '
        'type=${response.data.runtimeType} itemCount=$itemCount '
        'items=${_adminReportItemsSummary(response.data)}',
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
      _logAdminReport(
        'dio-error GET $endpoint status=${e.response?.statusCode} '
        'type=${e.type.name} body=${e.response?.data}',
      );
      if (e.response?.statusCode == HttpStatusCode.badRequest.code) {
        throw BadRequestParameterException();
      } else if (e.response?.statusCode == HttpStatusCode.forbidden.code) {
        throw NoAdminAuthorityException();
      }
      rethrow;
    } catch (e, stackTrace) {
      _logAdminReport('parse-error GET $endpoint error=$e\n$stackTrace');
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

  void _logSanctionStatus(String message) {
    if (kDebugMode) {
      debugPrint('[SanctionStatus][API] $message');
    }
  }

  void _logAdminReport(String message) {
    if (kDebugMode) {
      debugPrint('[AdminReport][API] $message');
    }
  }

  String _adminReportItemsSummary(Object? data) {
    if (data is! List) return 'unavailable';

    return data
        .map((item) {
          if (item is! Map) return {'type': item.runtimeType.toString()};

          return {
            'reportId': item['id'],
            'reportType': item['reportType'],
            'targetMemberId': item['targetMemberId'],
            'targetMemberNickname': item['targetMemberNickname'],
            'isProcessed': item['isProcessed'],
            'sanctionType': item['sanctionType'],
            'createdAt': item['createdAt'],
          };
        })
        .toList(growable: false)
        .toString();
  }
}
