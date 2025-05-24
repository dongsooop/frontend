import 'package:dongsoop/presentation/board/recruit/write/providers/tutoring_write_use_case_provider.dart';
import 'package:dongsoop/presentation/board/recruit/write/view_models/tutoring_write_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tutoringWriteViewModelProvider =
    StateNotifierProvider.autoDispose<TutoringWriteViewModel, AsyncValue<void>>(
        (ref) {
  final useCase = ref.watch(tutoringWriteUseCaseProvider);
  return TutoringWriteViewModel(useCase);
});
