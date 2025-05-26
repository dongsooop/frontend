import 'package:dongsoop/presentation/board/recruit/write/providers/recruit_write_use_case_provider.dart';
import 'package:dongsoop/presentation/board/recruit/write/view_models/recruit_write_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitWriteViewModelProvider =
    StateNotifierProvider.autoDispose<RecruitWriteViewModel, AsyncValue<void>>(
        (ref) {
  final useCase = ref.watch(recruitWriteUseCaseProvider);
  return RecruitWriteViewModel(useCase);
});
