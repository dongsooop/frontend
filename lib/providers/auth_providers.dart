import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/domain/auth/use_case/load_user_use_case.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/data/auth/data_source/auth_data_source_impl.dart';
import 'package:dongsoop/data/auth/repository/auth_repository_impl.dart';
import 'package:dongsoop/domain/auth/use_case/login_use_case.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:dongsoop/presentation/sign_in/sign_in_view_model.dart';
import 'package:dongsoop/data/auth/data_source/auth_data_source.dart';
import 'package:dongsoop/domain/auth/use_case/logout_use_case.dart';
import 'package:dongsoop/presentation/my_page/my_page_view_model.dart';

// 추후 기능, 책임 별로 providers 분리

// Data Source
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final plainDio = ref.watch(plainDioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final preferences = ref.watch(preferencesProvider);

  return AuthDataSourceImpl(plainDio, secureStorage, preferences);
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authDataSource = ref.watch(authDataSourceProvider);

  return AuthRepositoryImpl(authDataSource);
});

// Use Case
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final loadUseCaseProvider = Provider<LoadUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoadUserUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return LogoutUseCase(repository);
});

// View Model
final signInViewModelProvider = StateNotifierProvider<SignInViewModel, AsyncValue<void>>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);

  return SignInViewModel(loginUseCase, ref);
});

final myPageViewModelProvider =
StateNotifierProvider<MyPageViewModel, AsyncValue<User?>>((ref) {
  final loadUseCase = ref.watch(loadUseCaseProvider);
  final logoutUseCase = ref.watch(logoutUseCaseProvider);

  return MyPageViewModel(loadUseCase, logoutUseCase, ref);
});

// user info
final userSessionProvider = StateProvider<User?>((ref) => null);