import 'package:dio/dio.dart';
import 'package:dongsoop/core/network/app_check_interceptor.dart';

class PlainInterceptor extends Interceptor {
  final AppCheckInterceptor _appCheckInterceptor = AppCheckInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    _appCheckInterceptor.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _appCheckInterceptor.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  void dispose() {
    _appCheckInterceptor.dispose();
  }
}
