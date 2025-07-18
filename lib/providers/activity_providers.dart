// Data Source
import 'package:dongsoop/data/mypage/data_source/mypage_data_source.dart';
import 'package:dongsoop/domain/mypage/repository/mypage_repository.dart';
import 'package:dongsoop/domain/mypage/use_case/get_my_market_posts_use_case.dart';
import 'package:dongsoop/presentation/my_page/activity/activity_market_state.dart';
import 'package:dongsoop/presentation/my_page/activity/activity_market_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mypage/data_source/mypage_data_source_impl.dart';
import '../data/mypage/repository/mypage_repository_impl.dart';
import 'auth_dio.dart';

// DataSource
final mypageDataSourceProvider = Provider<MypageDataSource>((ref) {
  final authDio = ref.watch(authDioProvider);

  return MypageDataSourceImpl(authDio);
});

// Repository
final mypageRepositoryProvider = Provider<MypageRepository>((ref) {
  final mypageDataSource = ref.watch(mypageDataSourceProvider);

  return MypageRepositoryImpl(mypageDataSource);
});

// Use Case
final getMyMarketPostsUseCaseProvider = Provider<GetMyMarketPostsUseCase>((ref) {
  final repository = ref.watch(mypageRepositoryProvider);
  return GetMyMarketPostsUseCase(repository);
});

// View Model
final activityMarketViewModelProvider =
StateNotifierProvider.autoDispose<ActivityMarketViewModel, ActivityMarketState>((ref) {
  final getMyMarketPostsUseCase = ref.watch(getMyMarketPostsUseCaseProvider);

  return ActivityMarketViewModel(getMyMarketPostsUseCase);
});