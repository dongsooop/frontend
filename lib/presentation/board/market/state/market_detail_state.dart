import 'package:dongsoop/domain/board/market/entities/market_detail_entity.dart';

class MarketDetailState {
  final MarketDetailEntity? marketDetail;
  final bool isLoading;
  final bool isComplete;
  final String? error;

  MarketDetailState({
    this.marketDetail,
    this.isLoading = false,
    this.isComplete = false,
    this.error,
  });

  MarketDetailState copyWith({
    MarketDetailEntity? marketDetail,
    bool? isLoading,
    bool? isComplete,
    String? error,
  }) {
    return MarketDetailState(
      marketDetail: marketDetail ?? this.marketDetail,
      isLoading: isLoading ?? this.isLoading,
      isComplete: isComplete ?? this.isComplete,
      error: error ?? this.error,
    );
  }
}
