import 'package:dongsoop/data/board/market/data_sources/guest_market_data_source_impl.dart';
import 'package:dongsoop/data/board/market/data_sources/market_data_source_impl.dart';
import 'package:dongsoop/providers/auth_dio.dart';
import 'package:dongsoop/providers/plain_dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final guestMarketDataSourceProvider = Provider(
  (ref) => GuestMarketDataSourceImpl(ref.watch(plainDioProvider)),
);

final marketDataSourceProvider = Provider(
  (ref) => MarketDataSourceImpl(
    ref.watch(authDioProvider),
    createAuthDio(ref: ref, useAi: true),
  ),
);
