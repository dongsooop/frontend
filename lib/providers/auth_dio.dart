import 'package:dio/dio.dart';
import 'package:dongsoop/core/network/auth_interceptor.dart';
import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Dio createAuthDio({required Ref ref, bool useAi = false}) {
  final baseUrl = dotenv.get('BASE_URL');

  final dio = Dio(BaseOptions(baseUrl: baseUrl));

  final secureStorage = ref.watch(secureStorageProvider);
  final preferences = ref.watch(preferencesProvider);

  dio.interceptors.clear();
  dio.interceptors.add(AuthInterceptor(secureStorage, preferences, ref));

  return dio;
}

final authDioProvider = Provider<Dio>((ref) => createAuthDio(ref: ref));
