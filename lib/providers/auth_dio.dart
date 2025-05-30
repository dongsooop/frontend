import 'package:dio/dio.dart';
import 'package:dongsoop/core/network/auth_interceptor.dart';
import 'package:dongsoop/providers/secure_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/providers/auth_providers.dart';

final authDioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final secureStorage = ref.watch(secureStorageProvider);
  final authRepository = ref.watch(authRepositoryProvider);

  dio.interceptors.clear();
  dio.interceptors.add(AuthInterceptor(secureStorage, authRepository));

  return dio;
});