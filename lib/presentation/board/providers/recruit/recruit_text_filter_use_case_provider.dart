import 'package:dongsoop/domain/board/recruit/use_cases/recruit_text_filter_use_case.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitTextFilterUseCaseProvider =
    Provider<RecruitTextFilterUseCase>((ref) {
  final repository = ref.read(recruitRepositoryProvider);
  return RecruitTextFilterUseCase(repository);
});
