import 'package:dio/dio.dart';
import 'package:dongsoop/core/network/plain_interceptor.dart';
import 'package:dongsoop/providers/app_check_dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final plainDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: dotenv.get('BASE_URL'),
  ));
  final appCheck = ref.watch(appCheckInterceptorProvider);

  dio.interceptors.clear();
  dio.interceptors.add(appCheck);
  dio.interceptors.add(PlainInterceptor());

  return dio;
});
