import 'package:dongsoop/domain/board/recruit/use_cases/recruit_list_use_case.dart';
import 'package:dongsoop/presentation/board/providers/recruit/recruit_repository_provider.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitListUseCaseProvider = Provider<RecruitListUseCase>((ref) {
  final user = ref.watch(userSessionProvider);

  final repository = user != null
      ? ref.watch(recruitRepositoryProvider)
      : ref.watch(guestRecruitRepositoryProvider);

  return RecruitListUseCase(repository);
});
