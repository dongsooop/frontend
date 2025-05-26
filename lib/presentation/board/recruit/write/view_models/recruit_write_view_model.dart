import 'package:dongsoop/domain/board/recruit/entities/write/recruit_write_entity.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/write/recruit_write_use_case.dart';
import 'package:dongsoop/presentation/board/recruit/write/providers/recruit_write_use_case_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitWriteViewModelProvider =
    StateNotifierProvider<RecruitWriteViewModel, AsyncValue<void>>(
  (ref) {
    final useCase = ref.watch(recruitWriteUseCaseProvider);
    return RecruitWriteViewModel(useCase);
  },
);

class RecruitWriteViewModel extends StateNotifier<AsyncValue<void>> {
  final RecruitWriteUseCase useCase;
  bool _isSubmitting = false;

  RecruitWriteViewModel(this.useCase) : super(const AsyncValue.data(null));

  Future<void> submit(RecruitWriteEntity entity) async {
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
