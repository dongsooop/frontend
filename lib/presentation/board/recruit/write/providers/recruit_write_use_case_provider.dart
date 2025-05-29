import 'package:dongsoop/core/providers/dio_provider.dart';
import 'package:dongsoop/data/board/recruit/repositories/recruit_write_repository_impl.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/recruit_write_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recruitWriteUseCaseProvider = Provider<RecruitWriteUseCase>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = RecruitWriteRepositoryImpl(dio);
  return RecruitWriteUseCase(repository);
});
