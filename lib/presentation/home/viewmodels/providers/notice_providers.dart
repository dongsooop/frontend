import 'package:dio/dio.dart';
import 'package:dongsoop/data/repositories/home/notice_repository_impl.dart';
import 'package:dongsoop/domain/repositories/home/notice_repository.dart';
import 'package:dongsoop/domain/usecases/home/notice_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 공지사항 Repository Provider
/// Dio 인스턴스를 주입하여 실제 API 호출을 담당하는 구현체(NoticeRepositoryImpl)를 생성
/// NoticeRepository는 도메인 계층에서 사용하는 추상화된 인터페이스
final noticeRepositoryProvider = Provider<NoticeRepository>((ref) {
  return NoticeRepositoryImpl(Dio());
});

/// 공지사항 UseCase Provider
/// Repository를 주입받아 비즈니스 로직을 수행하는 UseCase를 생성
/// 외부에서는 이 UseCase를 통해 공지 데이터를 가져옴
final noticeUseCaseProvider = Provider<NoticeUseCase>((ref) {
  return NoticeUseCase(ref.watch(noticeRepositoryProvider));
});
