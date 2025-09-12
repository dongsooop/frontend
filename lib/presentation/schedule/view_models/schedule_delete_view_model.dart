import 'package:dongsoop/domain/schedule/use_cases/schedule_delete_use_case.dart';
import 'package:dongsoop/presentation/schedule/providers/schedule_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule_delete_view_model.g.dart';

class ScheduleDeleteState {
  final bool isLoading;
  final String? error;

  ScheduleDeleteState({this.isLoading = false, this.error});

  ScheduleDeleteState copyWith({bool? isLoading, String? error}) {
    return ScheduleDeleteState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

@riverpod
class ScheduleDeleteViewModel extends _$ScheduleDeleteViewModel {
  ScheduleDeleteUseCase get _useCase =>
      ref.watch(calendarDeleteUseCaseProvider);

  @override
  ScheduleDeleteState build() => ScheduleDeleteState();

  Future<void> delete({required int calendarId}) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);
    try {
      await _useCase.execute(calendarId: calendarId);
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
