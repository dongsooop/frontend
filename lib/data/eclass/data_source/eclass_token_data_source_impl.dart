import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/eclass_exception.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_token_data_source.dart';
import 'package:dongsoop/data/eclass/model/eclass_token_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EclassTokenDataSourceImpl implements EclassTokenDataSource {
  static const _service = 'moodle_mobile_app';

  final Dio _dio;

  EclassTokenDataSourceImpl(this._dio);

  @override
  Future<EclassTokenResponse> issueToken({
    required String eclassId,
    required String password,
  }) async {
    final endpoint = dotenv.get('ECLASS_TOKEN_ENDPOINT');

    try {
      final response = await _dio.post(
        endpoint,
        data: {
          'username': eclassId,
          'password': password,
          'service': _service,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      final data = _jsonMap(response.data);
      final errorCode = data['errorcode']?.toString().trim();
      final errorMessage = data['error']?.toString().trim();

      if (errorCode == 'invalidlogin') {
        throw EclassInvalidCredentialsException(
          errorMessage == null || errorMessage.isEmpty
              ? 'Eclass 아이디 또는 비밀번호를 확인해 주세요.'
              : errorMessage,
        );
      }
      if (errorCode != null && errorCode.isNotEmpty) {
        throw EclassTokenException(
          errorMessage == null || errorMessage.isEmpty
              ? 'Eclass 로그인에 실패했어요. 잠시 후 다시 시도해 주세요.'
              : errorMessage,
        );
      }

      final tokenResponse = EclassTokenResponse.fromJson(data);
      if (tokenResponse.token.trim().isEmpty) {
        throw const EclassMalformedResponseException(
          'Eclass 토큰이 비어 있습니다.',
        );
      }
      return tokenResponse;
    } on EclassException {
      rethrow;
    } on DioException catch (error) {
      final message = _errorMessage(error.response?.data);
      throw EclassTokenException(message);
    } on FormatException catch (error) {
      throw EclassMalformedResponseException(error.message);
    } catch (_) {
      throw const EclassMalformedResponseException();
    }
  }

  Map<String, dynamic> _jsonMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    throw FormatException(
      'Unexpected Eclass token response: ${value.runtimeType}',
    );
  }

  String _errorMessage(Object? value) {
    if (value is Map) {
      final message = value['error']?.toString().trim();
      if (message != null && message.isNotEmpty) return message;
    }
    return 'Eclass 로그인에 실패했어요. 잠시 후 다시 시도해 주세요.';
  }
}
