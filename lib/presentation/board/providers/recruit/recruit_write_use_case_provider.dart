import 'package:dongsoop/domain/board/recruit/use_cases/recruit_write_use_case.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitWriteUseCaseProvider = Provider<RecruitWriteUseCase>((ref) {
  final repository = ref.watch(recruitRepositoryProvider);
  return RecruitWriteUseCase(repository);
});
