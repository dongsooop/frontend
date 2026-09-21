import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/eclass_exception.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_device_request_options.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_link_data_source.dart';
import 'package:dongsoop/data/eclass/model/eclass_link_request.dart';
import 'package:dongsoop/data/eclass/model/eclass_link_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EclassLinkDataSourceImpl implements EclassLinkDataSource {
  final Dio _dio;

  EclassLinkDataSourceImpl(this._dio);

  @override
  Future<EclassLinkResponse> link({
    required EclassLinkRequest request,
    String? fid,
    String? deviceToken,
  }) async {
    final endpoint = dotenv.get('ECLASS_LINK_ENDPOINT');

    try {
      final response = await _dio.post(
        endpoint,
        data: request.toJson(),
        options: buildEclassDeviceRequestOptions(
          fid: fid,
          deviceToken: deviceToken,
        ),
      );
      if (response.statusCode != HttpStatusCode.ok.code) {
        throw EclassLinkException(
          'Eclass 연동에 실패했습니다. status: ${response.statusCode}',
        );
      }
      return EclassLinkResponse.fromJson(_jsonMap(response.data));
    } on EclassException {
      rethrow;
    } on DioException catch (error) {
      throw EclassLinkException(_problemDetail(error.response?.data));
    } on FormatException catch (error) {
      throw EclassMalformedResponseException(error.message);
    } catch (_) {
      throw const EclassMalformedResponseException();
    }
  }

  @override
  Future<EclassLinkResponse> getLink({
    String? fid,
    String? deviceToken,
  }) async {
    final endpoint = dotenv.get('ECLASS_LINK_ENDPOINT');

    try {
      final response = await _dio.get(
        endpoint,
        options: buildEclassDeviceRequestOptions(
          fid: fid,
          deviceToken: deviceToken,
        ),
      );
      if (response.statusCode != HttpStatusCode.ok.code) {
        throw EclassLinkException(
          'Eclass 연동 상태를 확인하지 못했습니다. status: ${response.statusCode}',
        );
      }
      return EclassLinkResponse.fromJson(_jsonMap(response.data));
    } on EclassException {
      rethrow;
    } on DioException catch (error) {
      throw EclassLinkException(_problemDetail(error.response?.data));
    } on FormatException catch (error) {
      throw EclassMalformedResponseException(error.message);
    } catch (_) {
      throw const EclassMalformedResponseException();
    }
  }

  @override
  Future<void> unlink({
    String? fid,
    String? deviceToken,
  }) async {
    final endpoint = dotenv.get('ECLASS_LINK_ENDPOINT');

    try {
      final response = await _dio.delete(
        endpoint,
        options: buildEclassDeviceRequestOptions(
          fid: fid,
          deviceToken: deviceToken,
        ),
      );
      if (response.statusCode != HttpStatusCode.noContent.code) {
        throw EclassLinkException(
          'Eclass 연동을 해제하지 못했습니다. status: ${response.statusCode}',
        );
      }
    } on EclassException {
      rethrow;
    } on DioException catch (error) {
      throw EclassLinkException(_problemDetail(error.response?.data));
    }
  }

  Map<String, dynamic> _jsonMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    throw FormatException(
      'Unexpected Eclass link response: ${value.runtimeType}',
    );
  }

  String _problemDetail(Object? value) {
    if (value is Map) {
      final detail = value['detail']?.toString().trim();
      if (detail != null && detail.isNotEmpty) return detail;
    }
    return 'Eclass 연동에 실패했어요. 잠시 후 다시 시도해 주세요.';
  }
}
