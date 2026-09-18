import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/eclass_exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_assignment_data_source.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_device_request_options.dart';
import 'package:dongsoop/data/eclass/model/eclass_assignments_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EclassAssignmentDataSourceImpl implements EclassAssignmentDataSource {
  final Dio _dio;

  EclassAssignmentDataSourceImpl(this._dio);

  @override
  Future<EclassAssignmentsResponse> getAssignments({
    String? fid,
    String? deviceToken,
  }) async {
    final endpoint = dotenv.get('ECLASS_ASSIGNMENTS_ENDPOINT');

    try {
      final response = await _dio.get(
        endpoint,
        options: buildEclassDeviceRequestOptions(
          fid: fid,
          deviceToken: deviceToken,
        ),
      );
      _debugLogAssignmentsResponse(
        statusCode: response.statusCode,
        data: response.data,
      );
      if (response.statusCode != HttpStatusCode.ok.code) {
        throw EclassAssignmentException(
          'Eclass 과제를 불러오지 못했습니다. status: ${response.statusCode}',
        );
      }
      return EclassAssignmentsResponse.fromJson(_jsonMap(response.data));
    } on EclassException {
      rethrow;
    } on DioException catch (error) {
      _debugLogAssignmentsResponse(
        statusCode: error.response?.statusCode,
        data: error.response?.data,
      );
      throw EclassAssignmentException(
        _problemDetail(
          error.response?.data,
          fallback: 'Eclass 과제를 불러오지 못했어요. 잠시 후 다시 시도해 주세요.',
        ),
      );
    } on FormatException catch (error) {
      throw EclassMalformedResponseException(error.message);
    } catch (_) {
      throw const EclassMalformedResponseException();
    }
  }

  @override
  Future<EclassSyncRemoteResult> sync({
    String? fid,
    String? deviceToken,
  }) async {
    final endpoint = dotenv.get('ECLASS_SYNC_ENDPOINT');

    try {
      final response = await _dio.post(
        endpoint,
        options: buildEclassDeviceRequestOptions(
          fid: fid,
          deviceToken: deviceToken,
        ),
      );
      if (response.statusCode != HttpStatusCode.noContent.code) {
        throw EclassSyncException(
          'Eclass 과제를 동기화하지 못했습니다. status: ${response.statusCode}',
        );
      }
      return EclassSyncRemoteResult.completed;
    } on EclassException {
      rethrow;
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode == HttpStatusCode.tooManyRequests.code) {
        return EclassSyncRemoteResult.rateLimited;
      }
      if (statusCode == HttpStatusCode.notFound.code) {
        throw EclassNotLinkedException(
          _problemDetail(
            error.response?.data,
            fallback: 'Eclass 연동 정보가 없어요. 먼저 Eclass를 연동해 주세요.',
          ),
        );
      }
      throw EclassSyncException(
        _problemDetail(
          error.response?.data,
          fallback: 'Eclass 과제를 동기화하지 못했어요. 잠시 후 다시 시도해 주세요.',
        ),
      );
    }
  }

  Map<String, dynamic> _jsonMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    throw FormatException(
      'Unexpected Eclass assignments response: ${value.runtimeType}',
    );
  }

  String _problemDetail(
    Object? value, {
    required String fallback,
  }) {
    if (value is Map) {
      final detail = value['detail']?.toString().trim();
      if (detail != null && detail.isNotEmpty) return detail;
    }
    return fallback;
  }

  void _debugLogAssignmentsResponse({
    required int? statusCode,
    required Object? data,
  }) {
    if (!kDebugMode) return;
    debugPrint('[EclassAssignments] GET status=$statusCode');
    try {
      final body = const JsonEncoder.withIndent('  ').convert(data);
      debugPrint('[EclassAssignments] response body:\n$body');
    } catch (error) {}
  }
}
