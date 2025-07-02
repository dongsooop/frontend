import 'package:dongsoop/data/board/market/repositories/guest_market_repository_impl.dart';
import 'package:dongsoop/data/board/market/repositories/market_repository_impl.dart';
import 'package:dongsoop/presentation/board/providers/market/market_data_source_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final guestMarketRepositoryProvider = Provider(
  (ref) => GuestMarketRepositoryImpl(ref.watch(guestMarketDataSourceProvider)),
);

final marketRepositoryProvider = Provider(
  (ref) => MarketRepositoryImpl(ref.watch(marketDataSourceProvider)),
);
