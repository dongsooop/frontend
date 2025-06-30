import 'package:dongsoop/domain/board/market/use_cases/market_complete_use_case.dart';
import 'package:dongsoop/domain/board/market/use_cases/market_delete_use_case.dart';
import 'package:dongsoop/domain/board/market/use_cases/market_detail_use_case.dart';
import 'package:dongsoop/main.dart';
import 'package:dongsoop/presentation/board/market/state/market_detail_state.dart';
import 'package:dongsoop/presentation/board/providers/market/market_complete_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/market/market_delete_use_case_provider.dart';
import 'package:dongsoop/presentation/board/providers/market/market_detail_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'market_detail_view_model.g.dart';

class MarketDetailArgs {
  final int id;

  const MarketDetailArgs({
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarketDetailArgs &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@riverpod
class MarketDetailViewModel extends _$MarketDetailViewModel {
  MarketDetailUseCase get _useCase => ref.watch(marketDetailUseCaseProvider);
  MarketDeleteUseCase get _deleteUseCase =>
      ref.watch(marketDeleteUseCaseProvider);
  MarketCompleteUseCase get _completeUseCase =>
      ref.watch(marketCompleteUseCaseProvider);

  @override
  FutureOr<MarketDetailState> build(MarketDetailArgs args) async {
    try {
      final marketDetail = await _useCase.execute(id: args.id);
      return MarketDetailState(
        marketDetail: marketDetail,
        isLoading: false,
      );
    } catch (e, stack) {
      logger.e('ViewModel build 실패', error: e, stackTrace: stack);
      return MarketDetailState(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteMarket(int marketId) async {
    try {
      await _deleteUseCase.execute(marketId: marketId);
      logger.i('[MARKET] 게시글 삭제 성공');
    } catch (e, st) {
      logger.e('[MARKET] 게시글 삭제 실패', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> completeMarket(int marketId) async {
    try {
      await _completeUseCase.execute(marketId: marketId);

      final current = state.value;
      if (current != null) {
        state = AsyncData(
          current.copyWith(
            isComplete: true,
          ),
        );
      }
    } catch (e, st) {
      logger.e('거래 완료 실패', error: e, stackTrace: st);
      rethrow;
    }
  }
}
