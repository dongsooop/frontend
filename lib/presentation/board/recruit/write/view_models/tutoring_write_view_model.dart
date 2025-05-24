import 'package:dongsoop/domain/board/recruit/entities/write/tutoring_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/write/tutoring_write_use_case.dart';
import 'package:dongsoop/presentation/board/recruit/write/providers/tutoring_write_use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tutoringWriteViewModelProvider =
    StateNotifierProvider<TutoringWriteViewModel, AsyncValue<void>>(
  (ref) {
    final useCase = ref.watch(tutoringWriteUseCaseProvider);
    return TutoringWriteViewModel(useCase);
  },
);

class TutoringWriteViewModel extends StateNotifier<AsyncValue<void>> {
  final TutoringWriteUseCase useCase;
  bool _isSubmitting = false;

  TutoringWriteViewModel(this.useCase) : super(const AsyncValue.data(null));

  Future<void> submit(TutoringWriteEntity entity) async {
    if (_isSubmitting) return; // 중복 요청 막기
    _isSubmitting = true;

    state = const AsyncValue.loading();
    try {
      await useCase(entity);
      if (mounted) {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      print('[ViewModel] 요청 실패: $e');
      if (mounted) {
        state = AsyncValue.error(e, st);
      }
    } finally {
      _isSubmitting = false;
    }
  }
}
