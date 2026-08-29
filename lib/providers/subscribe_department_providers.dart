import 'package:dongsoop/data/subscribe_department/data_source/subscribe_department_data_source.dart';
import 'package:dongsoop/data/subscribe_department/data_source/subscribe_department_data_source_impl.dart';
import 'package:dongsoop/data/subscribe_department/repository/subscribe_department_repository_impl.dart';
import 'package:dongsoop/domain/subscribe_department/repository/subscribe_department_repository.dart';
import 'package:dongsoop/domain/subscribe_department/use_case/get_subscribe_departments_use_case.dart';
import 'package:dongsoop/domain/subscribe_department/use_case/update_subscribe_departments_use_case.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// DataSource
final subscribeDepartmentDataSourceProvider = Provider<SubscribeDepartmentDataSource>((ref) {
  final dio = ref.read(plainDioProvider);
  return SubscribeDepartmentDataSourceImpl(dio);
});

// Repository
final subscribeDepartmentRepositoryProvider = Provider<SubscribeDepartmentRepository>((ref) {
  final dataSource = ref.read(subscribeDepartmentDataSourceProvider);
  return SubscribeDepartmentRepositoryImpl(dataSource);
});

// UseCases
final getSubscribeDepartmentsUseCaseProvider = Provider<GetSubscribeDepartmentsUseCase>((ref) {
  final repo = ref.read(subscribeDepartmentRepositoryProvider);
  return GetSubscribeDepartmentsUseCase(repo);
});

final updateSubscribeDepartmentsUseCaseProvider = Provider<UpdateSubscribeDepartmentsUseCase>((ref) {
  final repo = ref.read(subscribeDepartmentRepositoryProvider);
  return UpdateSubscribeDepartmentsUseCase(repo);
});
