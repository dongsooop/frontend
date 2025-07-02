import 'package:dongsoop/domain/board/market/use_cases/market_write_use_case.dart';
import 'package:dongsoop/presentation/board/providers/market/market_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketWriteUseCaseProvider = Provider<MarketWriteUseCase>((ref) {
  final repository = ref.read(marketRepositoryProvider);
  return MarketWriteUseCase(repository);
});
