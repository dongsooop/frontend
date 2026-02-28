import 'package:dio/dio.dart';
import 'package:dongsoop/core/exception/exception.dart';

mixin ErrorHandlerMixin {
  Never convertError(Object e) {
    if (e is DioException && e.error is SessionExpiredException) {
      throw e.error!;
    }
    throw e;
  }
}