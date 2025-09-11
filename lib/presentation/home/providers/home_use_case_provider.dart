import 'package:dongsoop/domain/home/use_case/home_use_case.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dongsoop/data/home/data_source/home_data_source.dart';
import 'package:dongsoop/data/home/data_source/home_data_source_impl.dart';
import 'package:dongsoop/data/home/repository/home_repository_impl.dart';
import 'package:dongsoop/domain/home/repository/home_repository.dart';

final homeDataSourceProvider = Provider<HomeDataSource>((ref) {
  final authDio  = ref.watch(authDioProvider);
  final plainDio = ref.watch(plainDioProvider);
  return HomeDataSourceImpl(authDio, plainDio);
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final dataSource = ref.watch(homeDataSourceProvider);
  return HomeRepositoryImpl(dataSource);
});

final homeUseCaseProvider = Provider<HomeUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return HomeUseCase(repository);
});
