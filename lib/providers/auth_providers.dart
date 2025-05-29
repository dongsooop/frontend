import 'package:dio/dio.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/domain/auth/repository/auth_repository.dart';
import 'package:dongsoop/data/auth/data_source/auth_data_source.dart';
import 'package:dongsoop/data/auth/data_source/remote_auth_data_source_impl.dart';
import 'package:dongsoop/data/auth/repository/auth_repository_impl.dart';
import 'package:dongsoop/domain/auth/use_case/login_use_case.dart';


final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final plainDio = ref.watch(plainDioProvider);
  return RemoteAuthDataSourceImpl(plainDio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});