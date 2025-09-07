import 'package:dongsoop/domain/calendar/entities/calendar_entity.dart';
import 'package:dongsoop/domain/calendar/use_cases/calendar_write_use_case.dart';
import 'package:dongsoop/presentation/calendar/providers/calendar_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calendar_write_view_model.g.dart';

class CalendarWriteState {
  final bool isLoading;
  final String? error;

  CalendarWriteState({this.isLoading = false, this.error});

  CalendarWriteState copyWith({bool? isLoading, String? error}) {
    return CalendarWriteState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

@riverpod
class CalendarWriteViewModel extends _$CalendarWriteViewModel {
  CalendarWriteUseCase get _useCase => ref.watch(calendarWriteUseCaseProvider);

  @override
  CalendarWriteState build() => CalendarWriteState();

  // `entity.id`가 없으면 ➝ 생성
  // `entity.id`가 있으면 ➝ 수정
  Future<void> submit(CalendarEntity entity) async {
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
    required CalendarEntity? original,
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
