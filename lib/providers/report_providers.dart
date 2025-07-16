import 'package:dongsoop/data/report/data_source/report_data_source.dart';
import 'package:dongsoop/domain/report/use_case/report_write_use_case.dart';
import 'package:dongsoop/presentation/report/report_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/report/data_source/report_data_source_impl.dart';
import '../data/report/repository/report_repository_impl.dart';
import '../domain/report/repository/report_repository.dart';
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

  return ReportRepositoryImpl(reportDataSource);
});

// Use Case
final reportWriteUseCaseProvider = Provider<ReportWriteUseCase>((ref) {
  final repository = ref.watch(reportRepositoryProvider);
  return ReportWriteUseCase(repository);
});

// View Model
final reportViewModelProvider =
StateNotifierProvider.autoDispose<ReportViewModel, ReportState>((ref) {
  final reportWriteUseCeseProvider = ref.watch(reportWriteUseCaseProvider);

  return ReportViewModel(reportWriteUseCeseProvider);
});