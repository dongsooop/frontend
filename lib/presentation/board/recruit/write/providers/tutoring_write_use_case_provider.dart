import 'package:dongsoop/core/providers/dio_provider.dart';
import 'package:dongsoop/data/board/recruit/repositories/write/tutoring_write_repository_impl.dart';
import 'package:dongsoop/domain/board/recruit/use_cases/write/tutoring_write_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tutoringWriteUseCaseProvider = Provider<TutoringWriteUseCase>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = TutoringWriteRepositoryImpl(dio, ref);
  return TutoringWriteUseCase(repository);
});
