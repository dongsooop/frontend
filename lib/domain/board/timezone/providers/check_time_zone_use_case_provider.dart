import 'package:dongsoop/domain/board/timezone/providers/check_time_zome_repository_provider.dart';
import 'package:dongsoop/domain/board/timezone/use_case/check_time_zone_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final checkTimeZoneUseCaseProvider = Provider<CheckTimeZoneUseCase>((ref) {
  final repository = ref.watch(checkTimeZoneRepositoryProvider);
  return CheckTimeZoneUseCase(repository);
});
