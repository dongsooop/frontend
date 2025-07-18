import 'package:dongsoop/domain/board/recruit/use_cases/recruit_delete_use_case.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitDeleteUseCaseProvider = Provider<RecruitDeleteUseCase>((ref) {
  final repository = ref.read(recruitRepositoryProvider);
  return RecruitDeleteUseCase(repository);
});
