import 'package:dongsoop/data/timetable/data_source/timetable_data_source.dart';
import 'package:dongsoop/data/timetable/data_source/timetable_data_source_impl.dart';
import 'package:dongsoop/data/timetable/repository/timetable_repository_impl.dart';
import 'package:dongsoop/domain/timetable/repository/timetable_repository.dart';
import 'package:dongsoop/domain/timetable/use_case/create_lecture_use_case.dart';
import 'package:dongsoop/domain/timetable/use_case/delete_lecture_use_case.dart';
import 'package:dongsoop/domain/timetable/use_case/get_lecture_use_case.dart';
import 'package:dongsoop/domain/timetable/use_case/update_lecture_use_case.dart';
import 'package:dongsoop/presentation/timetable/detail/timetable_detail_state.dart';
import 'package:dongsoop/presentation/timetable/detail/timetable_detail_view_model.dart';
import 'package:dongsoop/presentation/timetable/timetable_state.dart';
import 'package:dongsoop/presentation/timetable/timetable_view_model.dart';
import 'package:dongsoop/presentation/timetable/write/lecture_write_state.dart';
import 'package:dongsoop/presentation/timetable/write/lecture_write_view_model.dart';
import 'package:dongsoop/presentation/timetable/write/timetable_write_state.dart';
import 'package:dongsoop/presentation/timetable/write/timetable_write_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_dio.dart';

// Data Source
final timetableDataSourceProvider = Provider<TimetableDataSource>((ref) {
  final authDio = ref.watch(authDioProvider);

  return TimetableDataSourceImpl(authDio);
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

// View Model
final timetableViewModelProvider =
StateNotifierProvider.autoDispose<TimetableViewModel, TimetableState>((ref) {
  final getLectureUseCase = ref.watch(getLectureUseCaseProvider);

  return TimetableViewModel(getLectureUseCase);
});

final timetableDetailViewModelProvider =
StateNotifierProvider.autoDispose<TimetableDetailViewModel, TimetableDetailState>((ref) {
  final deleteLectureUseCase= ref.watch(deleteLectureUseCaseProvider);

  return TimetableDetailViewModel(deleteLectureUseCase);
});

final timetableWriteViewModelProvider =
StateNotifierProvider.autoDispose<TimetableWriteViewModel, TimetableWriteState>((ref) {

  return TimetableWriteViewModel();
});

final lectureWriteViewModelProvider =
StateNotifierProvider.autoDispose<LectureWriteViewModel, LectureWriteState>((ref) {
  final createLectureUseCase = ref.watch(createLectureUseCaseProvider);

  return LectureWriteViewModel(createLectureUseCase);
});