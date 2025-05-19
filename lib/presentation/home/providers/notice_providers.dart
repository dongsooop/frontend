import 'package:dio/dio.dart';
import 'package:dongsoop/data/notice/repositories/notice_repository_impl.dart';
import 'package:dongsoop/domain/notice/repositories/notice_repository.dart';
import 'package:dongsoop/domain/notice/use_cases/notice_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  return dio;
});

final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  return NoticeRepositoryImpl(ref.watch(dioProvider));
});

final noticeUseCaseProvider = Provider<NoticeUseCase>((ref) {
  return NoticeUseCase(ref.watch(noticeRepositoryProvider));
});
