import 'package:dongsoop/data/calendar/data_sources/calendar_data_source_impl.dart';
import 'package:dongsoop/data/calendar/repositories/calendar_repository_impl.dart';
import 'package:dongsoop/domain/calendar/use_cases/calendar_delete_use_case.dart';
import 'package:dongsoop/domain/calendar/use_cases/calendar_use_case.dart';
import 'package:dongsoop/domain/calendar/use_cases/calendar_write_use_case.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarDataSourceProvider = Provider<CalendarDataSourceImpl>((ref) {
  final dio = ref.watch(authDioProvider);
  return CalendarDataSourceImpl(dio);
});

final calendarRepositoryProvider = Provider<CalendarRepositoryImpl>((ref) {
  final dataSource = ref.watch(calendarDataSourceProvider);
  return CalendarRepositoryImpl(dataSource);
});

final calendarUseCaseProvider = Provider<CalendarUseCase>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  return CalendarUseCase(repository);
});

final calendarWriteUseCaseProvider = Provider<CalendarWriteUseCase>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  return CalendarWriteUseCase(repository);
});

final calendarDeleteUseCaseProvider = Provider<CalendarDeleteUseCase>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  return CalendarDeleteUseCase(repository);
});
