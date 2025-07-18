import 'package:dongsoop/data/report/data_source/report_data_source.dart';
import 'package:dongsoop/domain/report/use_case/get_sanction_status_use_case.dart';
import 'package:dongsoop/domain/report/use_case/report_write_use_case.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_sanction_state.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_sanction_view_model.dart';
import 'package:dongsoop/presentation/my_page/admin/report/report_admin_state.dart';
import 'package:dongsoop/presentation/report/report_state.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/report/data_source/report_data_source_impl.dart';
import '../data/report/repository/report_repository_impl.dart';
import '../domain/report/repository/report_repository.dart';
import '../domain/report/use_case/get_reports_use_case.dart';
import '../domain/report/use_case/report_admin_sanction_write_use_case.dart';
import '../presentation/my_page/admin/report/report_admin_view_model.dart';
import '../presentation/report/report_view_model.dart';
import 'auth_dio.dart';

// Data Source
final reportDataSourceProvider = Provider<ReportDataSource>((ref) {
  final authDio = ref.watch(authDioProvider);

  return ReportDataSourceImpl(authDio);
});

// Repository
final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final reportDataSource = ref.watch(reportDataSourceProvider);
  final authDataSource = ref.watch(authDataSourceProvider);

  return ReportRepositoryImpl(reportDataSource, authDataSource);
});

// Use Case
final reportWriteUseCaseProvider = Provider<ReportWriteUseCase>((ref) {
  final repository = ref.watch(reportRepositoryProvider);
  return ReportWriteUseCase(repository);
});

// Use Case
final getSanctionStatusUseCaseProvider = Provider<GetSanctionStatusUseCase>((ref) {
  final repository = ref.watch(reportRepositoryProvider);
  return GetSanctionStatusUseCase(repository);
});

final reportAdminSanctionWriteUseCaseProvider = Provider<ReportAdminSanctionWriteUseCase>((ref) {
  final repository = ref.watch(reportRepositoryProvider);
  return ReportAdminSanctionWriteUseCase(repository);
});

final getReportsUseCaseProvider = Provider<GetReportsUseCase>((ref) {
  final repository = ref.watch(reportRepositoryProvider);
  return GetReportsUseCase(repository);
});


// View Model
final reportViewModelProvider =
StateNotifierProvider.autoDispose<ReportViewModel, ReportState>((ref) {
  final reportWriteUseCese = ref.watch(reportWriteUseCaseProvider);

  return ReportViewModel(reportWriteUseCese);
});

final reportAdminViewModelProvider =
StateNotifierProvider.autoDispose<ReportAdminViewModel, ReportAdminState>((ref) {
  final getReportsUseCase = ref.watch(getReportsUseCaseProvider);

  return ReportAdminViewModel(getReportsUseCase);
});

final reportAdminSanctionViewModelProvider =
StateNotifierProvider.autoDispose<ReportAdminSanctionViewModel, ReportAdminSanctionState>((ref) {
  final reportAdminSanctionWriteUseCase = ref.watch(reportAdminSanctionWriteUseCaseProvider);

  return ReportAdminSanctionViewModel(reportAdminSanctionWriteUseCase);
});