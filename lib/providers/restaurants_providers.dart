import 'package:dongsoop/data/restaurants/data_source/restaurants_data_source.dart';
import 'package:dongsoop/data/restaurants/data_source/restaurants_data_source_impl.dart';
import 'package:dongsoop/data/restaurants/repository/restaurants_repository_impl.dart';
import 'package:dongsoop/domain/restaurants/repository/restaurants_repository.dart';
import 'package:dongsoop/domain/restaurants/use_case/check_restaurants_duplication_use_case.dart';
import 'package:dongsoop/domain/restaurants/use_case/create_restaurants_use_case.dart';
import 'package:dongsoop/domain/restaurants/use_case/get_restaurants_use_case.dart';
import 'package:dongsoop/domain/restaurants/use_case/search_kakao_use_case.dart';
import 'package:dongsoop/presentation/restaurants/restaurants_state.dart';
import 'package:dongsoop/presentation/restaurants/restaurants_view_model.dart';
import 'package:dongsoop/presentation/restaurants/write/restaurants_write_state.dart';
import 'package:dongsoop/presentation/restaurants/write/restaurants_write_view_model.dart';
import 'package:dongsoop/presentation/restaurants/write/search_kakao_state.dart';
import 'package:dongsoop/presentation/restaurants/write/search_kakao_view_model.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_dio.dart';

// Data Source
final restaurantsDataSourceProvider = Provider<RestaurantsDataSource>((ref) {
  final plainDio = ref.watch(plainDioProvider);
  final authDio = ref.watch(authDioProvider);

  return RestaurantsDataSourceImpl(plainDio, authDio);
});

// Repository
final restaurantsRepositoryProvider = Provider<RestaurantsRepository>((ref) {
  final restaurantsDataSource = ref.watch(restaurantsDataSourceProvider);

  return RestaurantsRepositoryImpl(restaurantsDataSource);
});

// Use Case
final restaurantsSearchKaKaoUseCaseProvider = Provider<SearchKakaoUseCase>((ref) {
  final repository = ref.watch(restaurantsRepositoryProvider);
  return SearchKakaoUseCase(repository);
});

final checkRestaurantsDuplicationUseCaseProvider = Provider<CheckRestaurantsDuplicationUseCase>((ref) {
  final repository = ref.watch(restaurantsRepositoryProvider);
  return CheckRestaurantsDuplicationUseCase(repository);
});

final createRestaurantsUseCaseProvider = Provider<CreateRestaurantsUseCase>((ref) {
  final repository = ref.watch(restaurantsRepositoryProvider);
  return CreateRestaurantsUseCase(repository);
});

final getRestaurantsUseCaseProvider = Provider<GetRestaurantsUseCase>((ref) {
  final repository = ref.watch(restaurantsRepositoryProvider);
  return GetRestaurantsUseCase(repository);
});

// View Model
final restaurantsViewModelProvider =
StateNotifierProvider.autoDispose<RestaurantsViewModel, RestaurantsState>((ref) {
  final getRestaurantsUseCase = ref.watch(getRestaurantsUseCaseProvider);

  return RestaurantsViewModel(getRestaurantsUseCase);
});

final restaurantsWriteViewModelProvider =
StateNotifierProvider.autoDispose<RestaurantsWriteViewModel, RestaurantsWriteState>((ref) {
  final checkRestaurantsDuplicationUseCase = ref.watch(checkRestaurantsDuplicationUseCaseProvider);
  final createRestaurantsUseCase = ref.watch(createRestaurantsUseCaseProvider);

  return RestaurantsWriteViewModel(checkRestaurantsDuplicationUseCase, createRestaurantsUseCase);
});

final searchKakaoViewModelProvider =
StateNotifierProvider.autoDispose<SearchKakaoViewModel, SearchKakaoState>((ref) {
  final restaurantsSearchKaKaoUseCase = ref.watch(restaurantsSearchKaKaoUseCaseProvider);

  return SearchKakaoViewModel(restaurantsSearchKaKaoUseCase);
});