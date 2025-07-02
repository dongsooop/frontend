import 'package:dongsoop/domain/board/market/use_cases/market_contact_use_case.dart';
import 'package:dongsoop/presentation/board/providers/market/market_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketContactUseCaseProvider = Provider<MarketContactUseCase>((ref) {
  final repository = ref.read(marketRepositoryProvider);
  return MarketContactUseCase(repository);
});
