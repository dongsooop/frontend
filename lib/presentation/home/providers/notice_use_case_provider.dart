import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/data/notice/data_sources/notice_data_source_impl.dart';
import 'package:dongsoop/data/notice/data_sources/notice_local_data_source_impl.dart';
import 'package:dongsoop/data/notice/repository/notice_repository_impl.dart';
import 'package:dongsoop/domain/notice/repository/notice_repository.dart';
import 'package:dongsoop/domain/notice/use_cases/notice_combined_use_case.dart';
import 'package:dongsoop/domain/notice/use_cases/notice_department_use_case.dart';
import 'package:dongsoop/domain/notice/use_cases/notice_home_use_case.dart';
import 'package:dongsoop/domain/notice/use_cases/notice_school_use_case.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 공통 Dio 기반 Remote DataSource + Remote Repository
final noticeRemoteRepositoryProvider = Provider<NoticeRepository>((ref) {
  final dio = ref.watch(plainDioProvider);
  final remote = NoticeDataSourceImpl(dio);
  return NoticeRepositoryImpl(remote, null); // local 없이
});

// 학교 공지용 UseCase (리스트 등에서 사용)
final NoticeSchoolUseCaseProvider = Provider<NoticeSchoolUseCase>((ref) {
  final repository = ref.watch(noticeRemoteRepositoryProvider);
  return NoticeSchoolUseCase(repository);
});

// 학과 공지용 UseCase (리스트 등에서 사용)
final NoticeDepartmentUseCaseProvider =
    Provider<NoticeDepartmentUseCase>((ref) {
  final repository = ref.watch(noticeRemoteRepositoryProvider);
  return NoticeDepartmentUseCase(repository);
});

// 전체 공지 병합용 UseCase (리스트 탭에서 사용)
final NoticeCombinedUseCaseProvider =
    FutureProvider<NoticeCombinedUseCase>((ref) async {
  final repository = ref.watch(noticeRemoteRepositoryProvider);
  return NoticeCombinedUseCase(repository);
});

// 홈 탭용 최신 3개 공지 병합 + 캐싱 처리 UseCase
final NoticeHomeUseCaseProvider =
    FutureProvider<NoticeHomeUseCase>((ref) async {
  final dio = ref.watch(plainDioProvider);

  final remote = NoticeDataSourceImpl(dio);
  final preferences = ref.read(preferencesProvider);
  final local = NoticeLocalDataSourceImpl(preferences);

  final repository = NoticeRepositoryImpl(remote, local);
  return NoticeHomeUseCase(repository, local);
});
