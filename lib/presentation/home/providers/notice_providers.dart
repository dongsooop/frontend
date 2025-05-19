import 'package:dio/dio.dart';
import 'package:dongsoop/data/notice/repositories/notice_repository_impl.dart';
import 'package:dongsoop/domain/notice/repositories/notice_repository.dart';
import 'package:dongsoop/domain/notice/use_cases/notice_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 공지사항 Repository Provider
/// Dio 인스턴스를 주입하여 실제 API 호출을 담당하는 구현체(NoticeRepositoryImpl)를 생성
/// NoticeRepository는 도메인 계층에서 사용하는 추상화된 인터페이스
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
