import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = dotenv.get('BASE_URL');
  final dio = Dio(BaseOptions(baseUrl: baseUrl));
  return dio;
});
