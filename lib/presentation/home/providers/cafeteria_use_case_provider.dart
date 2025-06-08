import 'package:dongsoop/data/cafeteria/data_sources/cafeteria_data_source_impl.dart';
import 'package:dongsoop/data/cafeteria/data_sources/cafeteria_local_data_source_impl.dart';
import 'package:dongsoop/data/cafeteria/repository/cafeteria_repository_impl.dart';
import 'package:dongsoop/domain/cafeteria/use_case/cafeteria_use_case.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cafeteriaUseCaseProvider = Provider<CafeteriaUseCase>((ref) {
  final dio = ref.watch(plainDioProvider);

  final remoteDataSource = CafeteriaDataSourceImpl(dio);
  final localDataSource = CafeteriaLocalDataSourceImpl();

  final repository = CafeteriaRepositoryImpl(
    remoteDataSource,
    localDataSource,
  );

  return CafeteriaUseCase(repository);
});
