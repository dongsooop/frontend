import 'package:dio/dio.dart';
import 'package:dongsoop/core/network/plain_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final plainDioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.interceptors.clear();
  dio.interceptors.add(PlainInterceptor());

  return dio;
});