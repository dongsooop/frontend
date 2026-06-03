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

final _noticeKeywordRepositoryProvider = Provider<NoticeKeywordRepository>((ref) {
  final dio = ref.watch(authDioProvider);
  final dataSource = NoticeKeywordDataSourceImpl(dio);
  return NoticeKeywordRepositoryImpl(dataSource);
});

final noticeKeywordViewModelProvider =
    StateNotifierProvider<NoticeKeywordViewModel, NoticeKeywordState>((ref) {
  final repository = ref.watch(_noticeKeywordRepositoryProvider);
  return NoticeKeywordViewModel(
    GetNoticeKeywordsUseCase(repository),
    AddNoticeKeywordUseCase(repository),
    DeleteNoticeKeywordUseCase(repository),
  );
});
