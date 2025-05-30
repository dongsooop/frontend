import 'package:dio/dio.dart';
import 'package:dongsoop/core/http_status_code.dart';
import 'package:dongsoop/main.dart';

class PlainInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i('➡️ [PLAIN] ${options.method} ${options.uri}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i('✅ [PLAIN] ${response.statusCode} ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('❌ [PLAIN] Error: ${err.response?.statusCode} ${err.message}');
    // 공통 에러 처리
    if (err.response?.statusCode == HttpStatusCode.internalServerError.code) {
      // 500 등
    }

    super.onError(err, handler);
  }
}