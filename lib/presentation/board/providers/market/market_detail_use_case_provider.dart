import 'package:dongsoop/domain/board/market/use_cases/market_detail_use_case.dart';
import 'package:dongsoop/presentation/board/providers/market/market_repository_provider.dart';
import 'package:dongsoop/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketDetailUseCaseProvider = Provider<MarketDetailUseCase>((ref) {
  final user = ref.watch(userSessionProvider);

  final repository = user != null
      ? ref.watch(marketRepositoryProvider)
      : ref.watch(guestMarketRepositoryProvider);

  return MarketDetailUseCase(repository);
});
