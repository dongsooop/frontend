import 'package:dongsoop/domain/board/market/use_cases/market_complete_use_case.dart';
import 'package:dongsoop/presentation/board/providers/market/market_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketCompleteUseCaseProvider = Provider<MarketCompleteUseCase>((ref) {
  final repository = ref.read(marketRepositoryProvider);
  return MarketCompleteUseCase(repository);
});
