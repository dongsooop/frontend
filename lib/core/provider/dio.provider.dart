import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 인증 필요한 Dio
final dioWithAuthProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
  ));

  return dio;
});

// 인증 필요 없는 Dio
final dioWithoutAuthProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: dotenv.env['BASE_URL']!,
  ));
});
