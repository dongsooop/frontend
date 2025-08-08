import 'package:dongsoop/data/mypage/data_source/mypage_data_source.dart';
import 'package:dongsoop/domain/mypage/repository/mypage_repository.dart';
import 'package:dongsoop/domain/mypage/use_case/get_my_market_posts_use_case.dart';
import 'package:dongsoop/domain/mypage/use_case/get_my_recruit_posts_use_case.dart';
import 'package:dongsoop/presentation/my_page/activity/activity_market_state.dart';
import 'package:dongsoop/presentation/my_page/activity/activity_market_view_model.dart';
import 'package:dongsoop/presentation/my_page/activity/blocked_user_state.dart';
import 'package:dongsoop/presentation/my_page/activity/blocked_user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/data/mypage/data_source/mypage_data_source_impl.dart';
import 'package:dongsoop/data/mypage/repository/mypage_repository_impl.dart';
import 'package:dongsoop/domain/mypage/use_case/get_blocked_user_list_use_case.dart';
import 'package:dongsoop/presentation/my_page/activity/activity_recruit_state.dart';
import 'package:dongsoop/presentation/my_page/activity/activity_recruit_view_model.dart';
import '../domain/mypage/use_case/un_block_use_case.dart';
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
final getMyRecruitPostsUseCaseProvider = Provider<GetMyRecruitPostsUseCase>((ref) {
  final repository = ref.watch(mypageRepositoryProvider);
  return GetMyRecruitPostsUseCase(repository);
});
final getBlockedUserListUseCaseProvider = Provider<GetBlockedUserListUseCase>((ref) {
  final repository = ref.watch(mypageRepositoryProvider);
  return GetBlockedUserListUseCase(repository);
});
final unBlockUseCaseProvider = Provider<UnBlockUseCase>((ref) {
  final repository = ref.watch(mypageRepositoryProvider);
  return UnBlockUseCase(repository);
});

// View Model
final activityMarketViewModelProvider =
StateNotifierProvider.autoDispose<ActivityMarketViewModel, ActivityMarketState>((ref) {
  final getMyMarketPostsUseCase = ref.watch(getMyMarketPostsUseCaseProvider);

  return ActivityMarketViewModel(getMyMarketPostsUseCase);
});

final activityRecruitViewModelProvider =
StateNotifierProvider.autoDispose<ActivityRecruitViewModel, ActivityRecruitState>((ref) {
  final getMyRecruitPostsUseCase = ref.watch(getMyRecruitPostsUseCaseProvider);

  return ActivityRecruitViewModel(getMyRecruitPostsUseCase);
});

final blockedUserViewModelProvider =
StateNotifierProvider.autoDispose<BlockedUserViewModel, BlockedUserState>((ref) {
  final getBlockedUserListUseCase = ref.watch(getBlockedUserListUseCaseProvider);
  final unBlockUseCase = ref.watch(unBlockUseCaseProvider);

  return BlockedUserViewModel(getBlockedUserListUseCase, unBlockUseCase);
});