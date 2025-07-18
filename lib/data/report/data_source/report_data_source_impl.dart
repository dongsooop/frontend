import 'package:dio/dio.dart';
import 'package:dongsoop/data/report/data_source/report_data_source.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_request.dart';
import 'package:dongsoop/domain/report/model/report_admin_sanction_response.dart';
import 'package:dongsoop/domain/report/model/report_sanction_response.dart';
import 'package:dongsoop/domain/report/model/report_write_request.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../core/exception/exception.dart';
import '../../../core/http_status_code.dart';
import '../../../main.dart';

class ReportDataSourceImpl implements ReportDataSource {
  final Dio _authDio;

  ReportDataSourceImpl(
      this._authDio,
  );

  @override
  Future<void> writeReport(ReportWriteRequest request) async {
    final endpoint = dotenv.get('REPORT_WRITE_ENDPOINT');

    try {
      await _authDio.post(endpoint, data: request.toJson());
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.badRequest.code) {
        throw SelfReportException();
      } else if (e.response?.statusCode == HttpStatusCode.forbidden.code) {
        throw AlreadySanctionedException();
      } else if (e.response?.statusCode == HttpStatusCode.notFound.code) {
        throw NotFoundException();
      } else if (e.response?.statusCode == HttpStatusCode.conflict.code) {
        throw DuplicateReportException();
      }
      logger.e("report error statusCode: ${e.response?.statusCode}");
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReportSanctionResponse> getSanctionStatus() async {
    final endpoint = dotenv.get('SANCTION_CHECK_ENDPOINT');

    try {
      final response = await _authDio.get(endpoint);

      if (response.statusCode == HttpStatusCode.ok.code) {
        final data = response.data;
        logger.i('report sanction Response data: $data');

        return ReportSanctionResponse.fromJson(data);
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } catch (e) {
      logger.e("report error: ${e}");
      rethrow;
    }
  }

  @override
  Future<void> sanctionWriteReport(ReportAdminSanctionRequest request) async {
    final endpoint = dotenv.get('SANCTION_WRITE_ENDPOINT');

    try {
      logger.i('sanction: ${request.toJson()}');
      final response = await _authDio.post(endpoint, data: request.toJson());
      if (response.statusCode == HttpStatusCode.created.code) {
        logger.i('제재 성공');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.badRequest.code) {
        throw SanctionRequestValidationException();
      } else if (e.response?.statusCode == HttpStatusCode.notFound.code) {
        throw NotFoundSanctionException();
      } else if (e.response?.statusCode == HttpStatusCode.conflict.code) {
        throw AlreadyProcessedException();
      }
      logger.e("report error statusCode: ${e.response?.statusCode}");
      rethrow;
    } catch (e) {
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
    final reports = dotenv.get('REPORTS_ENDPOINT');
    final query = 'filter=$type&sort=$sort&page=$page&size=$size';
    final endpoint = '$reports?$query';

    try {
      final response = await _authDio.get(endpoint);
      if (response.statusCode == HttpStatusCode.ok.code) {
        final List<dynamic> data = response.data;

        final List<ReportAdminSanctionResponse> reports = data.map((e) => ReportAdminSanctionResponse.fromJson(e as Map<String, dynamic>)).toList();

        return reports;
      }
      throw Exception('Unexpected status code: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatusCode.badRequest.code) {
        throw BadRequestParameterException();
      } else if (e.response?.statusCode == HttpStatusCode.forbidden.code) {
        throw NoAdminAuthorityException();
      }
      logger.e("report error statusCode: ${e.response?.statusCode}");
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}