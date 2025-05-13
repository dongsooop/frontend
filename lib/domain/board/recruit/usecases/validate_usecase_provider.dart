import 'package:dongsoop/domain/board/recruit/usecases/validate_write_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final validateWriteUseCaseProvider = Provider<ValidateWriteUseCase>((ref) {
  return ValidateWriteUseCase();
});
