import 'package:dongsoop/domain/schedule/entities/schedule_entity.dart';
import 'package:dongsoop/domain/schedule/use_cases/schedule_write_use_case.dart';
import 'package:dongsoop/presentation/schedule/providers/schedule_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'schedule_write_view_model.g.dart';

class ScheduleWriteState {
  final bool isLoading;
  final String? error;

  ScheduleWriteState({this.isLoading = false, this.error});

  ScheduleWriteState copyWith({bool? isLoading, String? error}) {
    return ScheduleWriteState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

@riverpod
class ScheduleWriteViewModel extends _$ScheduleWriteViewModel {
  ScheduleWriteUseCase get _useCase => ref.watch(calendarWriteUseCaseProvider);

  @override
  ScheduleWriteState build() => ScheduleWriteState();

  // `entity.id`가 없으면 ➝ 생성
  // `entity.id`가 있으면 ➝ 수정
  Future<void> submit(ScheduleEntity entity) async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true);

    try {
      await _useCase.execute(entity: entity);
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  bool isChanged({
    required ScheduleEntity? original,
    required String title,
    required String location,
    required DateTime startAt,
    required DateTime endAt,
  }) {
    if (original == null) return true;

    final titleChanged = original.title != title;
    final locationChanged = original.location != location;
    final startChanged = original.startAt != startAt;
    final endChanged = original.endAt != endAt;

    return titleChanged || locationChanged || startChanged || endChanged;
  }

  void clearError() => state = state.copyWith(error: null);
}
