import 'package:dio/dio.dart';
import 'package:dongsoop/core/storage/hive_service.dart';
import 'package:dongsoop/data/timetable/data_source/timetable_data_source.dart';
import 'package:dongsoop/data/timetable/data_source/timetable_data_source_impl.dart';
import 'package:dongsoop/data/timetable/repository/timetable_repository_impl.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';
import 'package:dongsoop/domain/timetable/use_case/check_local_timetable_use_case.dart';
import 'package:dongsoop/domain/timetable/use_case/create_lecture_use_case.dart';
import 'package:dongsoop/domain/timetable/use_case/create_timetable_use_case.dart';
import 'package:dongsoop/domain/timetable/use_case/delete_lecture_use_case.dart';
import 'package:dongsoop/domain/timetable/use_case/delete_timetable_use_case.dart';
import 'package:dongsoop/domain/timetable/use_case/get_analysis_timetable_use_case.dart';
import 'package:dongsoop/domain/timetable/use_case/get_lecture_use_case.dart';
import 'package:dongsoop/domain/timetable/use_case/get_timetable_info_use_case.dart';
import 'package:dongsoop/domain/timetable/use_case/save_multiple_timetable_use_case.dart';
import 'package:dongsoop/domain/timetable/use_case/update_lecture_use_case.dart';
import 'package:dongsoop/presentation/timetable/detail/timetable_detail_state.dart';
import 'package:dongsoop/presentation/timetable/detail/timetable_detail_view_model.dart';
import 'package:dongsoop/presentation/timetable/list/timetable_list_state.dart';
import 'package:dongsoop/presentation/timetable/list/timetable_list_view_model.dart';
import 'package:dongsoop/presentation/timetable/timetable_state.dart';
import 'package:dongsoop/presentation/timetable/timetable_view_model.dart';
import 'package:dongsoop/presentation/timetable/write/lecture_write_state.dart';
import 'package:dongsoop/presentation/timetable/write/lecture_write_view_model.dart';
import 'package:dongsoop/presentation/timetable/write/timetable_write_state.dart';
import 'package:dongsoop/presentation/timetable/write/timetable_write_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_dio.dart';


final aiDioProvider = Provider<Dio>((ref) => createAuthDio(ref: ref, useAi: true));

// Data Source
final timetableDataSourceProvider = Provider<TimetableDataSource>((ref) {
  final authDio = ref.watch(authDioProvider);
  final aiDio = ref.watch(aiDioProvider);
  final hiveService = ref.watch(hiveServiceProvider);

  return TimetableDataSourceImpl(authDio, aiDio, hiveService);
});

// Repository
final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  final timetableDataSource = ref.watch(timetableDataSourceProvider);

  return TimetableRepositoryImpl(timetableDataSource);
});

// Use Case
final createLectureUseCaseProvider = Provider<CreateLectureUseCase>((ref) {
  final repository = ref.watch(timetableRepositoryProvider);
  return CreateLectureUseCase(repository);
});

final deleteLectureUseCaseProvider = Provider<DeleteLectureUseCase>((ref) {
  final repository = ref.watch(timetableRepositoryProvider);
  return DeleteLectureUseCase(repository);
});

final getLectureUseCaseProvider = Provider<GetLectureUseCase>((ref) {
  final repository = ref.watch(timetableRepositoryProvider);
  return GetLectureUseCase(repository);
});

final updateLectureUseCaseProvider = Provider<UpdateLectureUseCase>((ref) {
  final repository = ref.watch(timetableRepositoryProvider);
  return UpdateLectureUseCase(repository);
});

final checkLocalTimetableUseCaseProvider = Provider<CheckLocalTimetableUseCase>((ref) {
  final repository = ref.watch(timetableRepositoryProvider);
  return CheckLocalTimetableUseCase(repository);
});

final createTimetableUseCaseProvider = Provider<CreateTimetableUseCase>((ref) {
  final repository = ref.watch(timetableRepositoryProvider);
  return CreateTimetableUseCase(repository);
});

final getTimetableInfoUseCaseProvider = Provider<GetTimetableInfoUseCase>((ref) {
  final repository = ref.watch(timetableRepositoryProvider);
  return GetTimetableInfoUseCase(repository);
});

final deleteTimetableUseCaseProvider = Provider<DeleteTimetableUseCase>((ref) {
  final repository = ref.watch(timetableRepositoryProvider);
  return DeleteTimetableUseCase(repository);
});

final getAnalysisTimetableUseCaseProvider = Provider<GetAnalysisTimetableUseCase>((ref) {
  final repository = ref.watch(timetableRepositoryProvider);
  return GetAnalysisTimetableUseCase(repository);
});

final saveMultipleTimetableUseCaseProvider = Provider<SaveMultipleTimetableUseCase>((ref) {
  final repository = ref.watch(timetableRepositoryProvider);
  return SaveMultipleTimetableUseCase(repository);
});

// View Model
final timetableViewModelProvider =
StateNotifierProvider.autoDispose<TimetableViewModel, TimetableState>((ref) {
  final getLectureUseCase = ref.watch(getLectureUseCaseProvider);
  final checkLocalTimetableUseCase = ref.watch(checkLocalTimetableUseCaseProvider);

  return TimetableViewModel(getLectureUseCase, checkLocalTimetableUseCase);
});

final timetableDetailViewModelProvider =
StateNotifierProvider.autoDispose<TimetableDetailViewModel, TimetableDetailState>((ref) {
  final deleteLectureUseCase= ref.watch(deleteLectureUseCaseProvider);
  final getAnalysisTimetableUseCase = ref.watch(getAnalysisTimetableUseCaseProvider);
  final saveMultipleTimetableUseCase = ref.watch(saveMultipleTimetableUseCaseProvider);

  return TimetableDetailViewModel(deleteLectureUseCase, getAnalysisTimetableUseCase, saveMultipleTimetableUseCase);
});

final timetableWriteViewModelProvider =
StateNotifierProvider.autoDispose<TimetableWriteViewModel, TimetableWriteState>((ref) {
  final createTimetableUseCase= ref.watch(createTimetableUseCaseProvider);

  return TimetableWriteViewModel(createTimetableUseCase);
});

final timetableListViewModelProvider =
StateNotifierProvider.autoDispose<TimetableListViewModel, TimetableListState>((ref) {
  final getTimetableInfoUseCase = ref.watch(getTimetableInfoUseCaseProvider);
  final deleteTimetableUseCase = ref.watch(deleteTimetableUseCaseProvider);

  return TimetableListViewModel(getTimetableInfoUseCase, deleteTimetableUseCase);
});

final lectureWriteViewModelProvider =
StateNotifierProvider.autoDispose<LectureWriteViewModel, LectureWriteState>((ref) {
  final createLectureUseCase = ref.watch(createLectureUseCaseProvider);
  final updateLectureUseCase = ref.watch(updateLectureUseCaseProvider);

  return LectureWriteViewModel(createLectureUseCase, updateLectureUseCase);
});