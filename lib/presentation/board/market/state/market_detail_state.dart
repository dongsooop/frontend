import 'package:dongsoop/domain/board/market/entities/market_detail_entity.dart';

class MarketDetailState {
  final MarketDetailEntity? marketDetail;
  final bool isLoading;
  final String? error;
  final bool isButtonEnabled;

  const MarketDetailState({
    this.marketDetail,
    this.isLoading = false,
    this.error,
    this.isButtonEnabled = true,
  });

  MarketDetailState copyWith({
    MarketDetailEntity? marketDetail,
    bool? isLoading,
    String? error,
    bool? isButtonEnabled,
  }) {
    return MarketDetailState(
      marketDetail: marketDetail ?? this.marketDetail,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isButtonEnabled: isButtonEnabled ?? this.isButtonEnabled,
    );
  }
}
