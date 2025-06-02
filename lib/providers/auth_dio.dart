import 'package:dio/dio.dart';
import 'package:dongsoop/core/network/auth_interceptor.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authDioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: dotenv.get('BASE_URL'),));

  final secureStorage = ref.watch(secureStorageProvider);
  final preferences = ref.watch(preferencesProvider);

  dio.interceptors.clear();
  dio.interceptors.add(AuthInterceptor(secureStorage, preferences, ref));

  return dio;
});