import 'package:dongsoop/providers/plain_dio.dart';
import 'package:dongsoop/data/schedule/data_sources/schedule_data_source_impl.dart';
import 'package:dongsoop/data/schedule/repositories/schedule_repository_impl.dart';
import 'package:dongsoop/domain/schedule/use_cases/schedule_delete_use_case.dart';
import 'package:dongsoop/domain/schedule/use_cases/schedule_use_case.dart';
import 'package:dongsoop/domain/schedule/use_cases/schedule_write_use_case.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarRepositoryProvider = Provider<ScheduleRepositoryImpl>((ref) {
  final authDio = ref.watch(authDioProvider);
  final plainDio = ref.watch(plainDioProvider);
  final dataSource = ScheduleDataSourceImpl(authDio, plainDio);
  return ScheduleRepositoryImpl(dataSource);
});

final calendarUseCaseProvider = Provider<ScheduleUseCase>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  return ScheduleUseCase(repository);
});

final calendarWriteUseCaseProvider = Provider<ScheduleWriteUseCase>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  return ScheduleWriteUseCase(repository);
});

final calendarDeleteUseCaseProvider = Provider<ScheduleDeleteUseCase>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  return ScheduleDeleteUseCase(repository);
});
