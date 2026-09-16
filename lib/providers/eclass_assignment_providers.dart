import 'package:dongsoop/data/eclass/data_source/eclass_assignment_data_source.dart';
import 'package:dongsoop/data/eclass/data_source/eclass_assignment_data_source_impl.dart';
import 'package:dongsoop/data/eclass/repository/eclass_assignment_repository_impl.dart';
import 'package:dongsoop/domain/eclass/repository/eclass_assignment_repository.dart';
import 'package:dongsoop/domain/eclass/use_case/get_eclass_assignments_use_case.dart';
import 'package:dongsoop/domain/eclass/use_case/sync_eclass_assignments_use_case.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eclassAssignmentDataSourceProvider =
    Provider<EclassAssignmentDataSource>((ref) {
  return EclassAssignmentDataSourceImpl(ref.watch(plainDioProvider));
});

final eclassAssignmentRepositoryProvider =
    Provider<EclassAssignmentRepository>((ref) {
  return EclassAssignmentRepositoryImpl(
    ref.watch(eclassAssignmentDataSourceProvider),
  );
});

final getEclassAssignmentsUseCaseProvider =
    Provider<GetEclassAssignmentsUseCase>((ref) {
  return GetEclassAssignmentsUseCase(
    ref.watch(eclassAssignmentRepositoryProvider),
  );
});

final syncEclassAssignmentsUseCaseProvider =
    Provider<SyncEclassAssignmentsUseCase>((ref) {
  return SyncEclassAssignmentsUseCase(
    ref.watch(eclassAssignmentRepositoryProvider),
  );
});
