import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';

mixin ErrorHandlerMixin {
  Object convertError(Object e) {
    if (e is DioException && e.error is SessionExpiredException) {
      return e.error!;
    }
    return e;
  }
}