import 'package:dongsoop/data/notice/keyword/data_sources/notice_keyword_data_source.dart';
import 'package:dongsoop/data/notice/keyword/data_sources/notice_keyword_data_source_impl.dart';
import 'package:dongsoop/data/notice/keyword/repository/notice_keyword_repository_impl.dart';
import 'package:dongsoop/domain/notice/keyword/repository/notice_keyword_repository.dart';
import 'package:dongsoop/domain/notice/keyword/use_cases/add_notice_keyword_use_case.dart';
import 'package:dongsoop/domain/notice/keyword/use_cases/delete_notice_keyword_use_case.dart';
import 'package:dongsoop/domain/notice/keyword/use_cases/get_notice_keywords_use_case.dart';
import 'package:dongsoop/presentation/notice/keyword/view_models/notice_keyword_state.dart';
import 'package:dongsoop/presentation/notice/keyword/view_models/notice_keyword_view_model.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Data Source
final noticeDataSourceProvider = Provider<NoticeKeywordDataSource>((ref) {
  final authDio = ref.watch(authDioProvider);

  return NoticeKeywordDataSourceImpl(authDio);
});

// Repository
final noticeKeywordRepositoryProvider = Provider<NoticeKeywordRepository>((ref) {
  final restaurantsDataSource = ref.watch(noticeDataSourceProvider);

  return NoticeKeywordRepositoryImpl(restaurantsDataSource);
});

final getNoticeKeywordsUseCaseProvider = Provider<GetNoticeKeywordsUseCase>((ref) {
  final repository = ref.watch(noticeKeywordRepositoryProvider);
  return GetNoticeKeywordsUseCase(repository);
});

final addNoticeKeywordUseCaseProvider = Provider<AddNoticeKeywordUseCase>((ref) {
  final repository = ref.watch(noticeKeywordRepositoryProvider);
  return AddNoticeKeywordUseCase(repository);
});

final deleteNoticeKeywordUseCaseProvider = Provider<DeleteNoticeKeywordUseCase>((ref) {
  final repository = ref.watch(noticeKeywordRepositoryProvider);
  return DeleteNoticeKeywordUseCase(repository);
});

final noticeKeywordViewModelProvider = StateNotifierProvider.autoDispose<NoticeKeywordViewModel, NoticeKeywordState>((ref) {
  final getNoticeKeywordsUseCase = ref.watch(getNoticeKeywordsUseCaseProvider);
  final addNoticeKeywordUseCase = ref.watch(addNoticeKeywordUseCaseProvider);
  final deleteNoticeKeywordUseCase = ref.watch(deleteNoticeKeywordUseCaseProvider);

  return NoticeKeywordViewModel(getNoticeKeywordsUseCase, addNoticeKeywordUseCase, deleteNoticeKeywordUseCase);
});