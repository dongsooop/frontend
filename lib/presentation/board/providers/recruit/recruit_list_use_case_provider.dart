import 'package:dongsoop/core/providers/dio_provider.dart';
import 'package:dongsoop/data/board/recruit/repositories/recruit_list_repository_impl.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_list_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitListUseCaseProvider = Provider<RecruitListUseCase>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = RecruitListRepositoryImpl(dio);
  return RecruitListUseCase(repository);
});
