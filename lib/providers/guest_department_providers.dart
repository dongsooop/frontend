import 'package:dongsoop/data/guest_department/data_source/guest_department_data_source.dart';
import 'package:dongsoop/data/guest_department/data_source/guest_department_data_source_impl.dart';
import 'package:dongsoop/data/guest_department/repository/guest_department_repository_impl.dart';
import 'package:dongsoop/domain/guest_department/repository/guest_department_repository.dart';
import 'package:dongsoop/domain/guest_department/use_case/get_guest_departments_use_case.dart';
import 'package:dongsoop/domain/guest_department/use_case/update_guest_departments_use_case.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// DataSource
final guestDepartmentDataSourceProvider = Provider<GuestDepartmentDataSource>((ref) {
  final dio = ref.read(plainDioProvider);
  return GuestDepartmentDataSourceImpl(dio);
});

// Repository
final guestDepartmentRepositoryProvider = Provider<GuestDepartmentRepository>((ref) {
  final dataSource = ref.read(guestDepartmentDataSourceProvider);
  return GuestDepartmentRepositoryImpl(dataSource);
});

// UseCases
final getGuestDepartmentsUseCaseProvider = Provider<GetGuestDepartmentsUseCase>((ref) {
  final repo = ref.read(guestDepartmentRepositoryProvider);
  return GetGuestDepartmentsUseCase(repo);
});

final updateGuestDepartmentsUseCaseProvider = Provider<UpdateGuestDepartmentsUseCase>((ref) {
  final repo = ref.read(guestDepartmentRepositoryProvider);
  return UpdateGuestDepartmentsUseCase(repo);
});
