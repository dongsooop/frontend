import 'package:dongsoop/core/storage/preferences_service.dart';
import 'package:dongsoop/domain/auth/use_case/delete_user_use_case.dart';
import 'package:dongsoop/domain/auth/use_case/load_user_use_case.dart';
import 'package:dongsoop/presentation/sign_up/sign_up_state.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:dongsoop/providers/chat_providers.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:dongsoop/core/storage/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/data/auth/data_source/auth_data_source_impl.dart';
import 'package:dongsoop/data/auth/repository/auth_repository_impl.dart';
import 'package:dongsoop/domain/auth/use_case/sign_in_use_case.dart';
import 'package:dongsoop/domain/auth/model/user.dart';
import 'package:dongsoop/presentation/sign_in/sign_in_view_model.dart';
import 'package:dongsoop/data/auth/data_source/auth_data_source.dart';
import 'package:dongsoop/domain/auth/use_case/logout_use_case.dart';
import 'package:dongsoop/presentation/my_page/my_page_view_model.dart';
import 'package:dongsoop/domain/auth/use_case/check_duplicate_use_case.dart';
import 'package:dongsoop/domain/auth/use_case/sign_up_use_case.dart';
import 'package:dongsoop/presentation/sign_up/sign_up_view_model.dart';
import 'package:dongsoop/domain/auth/use_case/check_email_code_use_case.dart';
import 'package:dongsoop/domain/auth/use_case/send_email_code_use_case.dart';

// Data Source
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final plainDio = ref.watch(plainDioProvider);
  final authDio = ref.watch(authDioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final preferences = ref.watch(preferencesProvider);

  return AuthDataSourceImpl(plainDio, authDio, secureStorage, preferences);
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authDataSource = ref.watch(authDataSourceProvider);

  return AuthRepositoryImpl(authDataSource);
});

// Use Case
final SignInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInUseCase(repository);
});

final loadUserUseCaseProvider = Provider<LoadUserUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoadUserUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return LogoutUseCase(repository);
});

final deleteUserUseCaseProvider = Provider<DeleteUserUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final chatRepository = ref.watch(chatRepositoryProvider);

  return DeleteUserUseCase(authRepository, chatRepository);
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpUseCase(repository);
});

final checkDuplicateUseCaseProvider = Provider<CheckDuplicateUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return CheckDuplicateUseCase(repository);
});
final checkEmailCodeUseCaseProvider = Provider<CheckEmailCodeUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return CheckEmailCodeUseCase(repository);
});
final sendEmailCodeUseCaseProvider = Provider<SendEmailCodeUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SendEmailCodeUseCase(repository);
});

// View Model
final signInViewModelProvider = StateNotifierProvider<SignInViewModel, AsyncValue<void>>((ref) {
  final loginUseCase = ref.watch(SignInUseCaseProvider);
  final loadUserUseCase = ref.watch(loadUserUseCaseProvider);

  return SignInViewModel(loginUseCase, loadUserUseCase, ref);
});

final signUpViewModelProvider = StateNotifierProvider.autoDispose<SignUpViewModel, SignUpState>((ref) {
  final signUpUseCase = ref.watch(signUpUseCaseProvider);
  final checkDuplicateUseCase = ref.watch(checkDuplicateUseCaseProvider);
  final checkEmailCodeUseCase = ref.watch(checkEmailCodeUseCaseProvider);
  final sendEmailCodeUseCase = ref.watch(sendEmailCodeUseCaseProvider);

  return SignUpViewModel(signUpUseCase, checkDuplicateUseCase, checkEmailCodeUseCase, sendEmailCodeUseCase);
});

final myPageViewModelProvider =
StateNotifierProvider<MyPageViewModel, AsyncValue<User?>>((ref) {
  final loadUserUseCase = ref.watch(loadUserUseCaseProvider);

  return MyPageViewModel(loadUserUseCase, ref);
});



// user info
final userSessionProvider = StateProvider<User?>((ref) => null);