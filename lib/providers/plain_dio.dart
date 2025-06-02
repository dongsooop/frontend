import 'package:dio/dio.dart';
import 'package:dongsoop/core/network/plain_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final plainDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: dotenv.get('BASE_URL'),));

  dio.interceptors.clear();
  dio.interceptors.add(PlainInterceptor());

  return dio;
});