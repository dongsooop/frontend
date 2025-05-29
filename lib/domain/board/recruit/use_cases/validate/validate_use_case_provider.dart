import 'package:dongsoop/domain/board/recruit/use_cases/validate/validate_write_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final validateWriteUseCaseProvider = Provider<ValidateWriteUseCase>((ref) {
  return ValidateWriteUseCase();
});
