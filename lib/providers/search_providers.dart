import 'package:dongsoop/domain/search/config/search_config.dart';
import 'package:dongsoop/domain/search/use_case/search_market_use_case.dart';
import 'package:dongsoop/domain/search/use_case/search_notice_use_case.dart';
import 'package:dongsoop/domain/search/use_case/search_recruit_use_case.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/data/search/data_source/search_data_source.dart';
import 'package:dongsoop/data/search/data_source/search_data_source_impl.dart';
import 'package:dongsoop/data/search/repository/search_repository_impl.dart';
import 'package:dongsoop/domain/search/repository/search_repository.dart';

final searchDataSourceProvider = Provider<SearchDataSource>((ref) {
  final plainDio = ref.watch(plainDioProvider);
  final authDio = ref.watch(authDioProvider);
  return SearchDataSourceImpl(plainDio, authDio);
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final datasource = ref.watch(searchDataSourceProvider);
  return SearchRepositoryImpl(datasource);
});

final searchNoticeUseCaseProvider = Provider<SearchNoticeUseCase>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchNoticeUseCase(repository, const SearchConfig());
});

final searchRecruitUseCaseProvider = Provider<SearchRecruitUseCase>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchRecruitUseCase(repository, const SearchConfig());
});

final searchMarketUseCaseProvider = Provider<SearchMarketUseCase>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchMarketUseCase(repository, const SearchConfig());
});
