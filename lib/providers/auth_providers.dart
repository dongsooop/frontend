import 'package:dongsoop/data/auth/data_source/local_auth_data_source_impl.dart';
import 'package:dongsoop/domain/auth/use_case/load_user_use_case.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:dongsoop/providers/secure_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/data/auth/data_source/remote_auth_data_source.dart';
import 'package:dongsoop/data/auth/data_source/remote_auth_data_source_impl.dart';
import 'package:dongsoop/data/auth/repository/auth_repository_impl.dart';
import 'package:dongsoop/domain/auth/use_case/login_use_case.dart';
import 'package:dongsoop/data/auth/data_source/local_auth_data_source.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:dongsoop/presentation/sign_in/sign_in_view_model.dart';
import '../domain/auth/use_case/logout_use_case.dart';
import '../presentation/my_page/my_page_view_model.dart';

// 추후 기능, 책임 별로 providers 분리

// Data Source
final remoteAuthDataSourceProvider = Provider<RemoteAuthDataSource>((ref) {
  final plainDio = ref.watch(plainDioProvider);
  return RemoteAuthDataSourceImpl(plainDio);
});

final localAuthDataSourceProvider = Provider<LocalAuthDataSource>((ref) {
  return LocalAuthDataSourceImpl();
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(remoteAuthDataSourceProvider);
  final localDataSource = ref.watch(localAuthDataSourceProvider);

  return AuthRepositoryImpl(remoteDataSource, localDataSource);
});

// Use Case
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return LoginUseCase(repository, secureStorage);
});

final loadUseCaseProvider = Provider<LoadUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoadUserUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);

  return LogoutUseCase(repository, secureStorage);
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