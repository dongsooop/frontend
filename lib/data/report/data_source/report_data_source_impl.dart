import 'package:dio/dio.dart';
import 'package:dongsoop/data/report/data_source/report_data_source.dart';
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
      final response = await _authDio.post(endpoint, data: request.toJson());
      if (response.statusCode == HttpStatusCode.created.code) {
        logger.i('신고 성공');
      }
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
}